import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _LaytoutAction {
  _LaytoutAction(this.draggedItem, this.dropPosition);

  final DockingItem draggedItem;
  final DropPosition dropPosition;
}

mixin DropArea {
  _LaytoutAction? _layoutAction;
}

/// Represents any area of the layout.
abstract class DockingArea {
  DockingArea() : this._id = DockingLayout._randomId();

  /// Id used to debugger.
  final int _id;

  int _layoutId = -1;

  /// The index in the layout.
  int _index = -1;

  /// Gets the index of this area in the layout.
  ///
  /// If the area is outside the layout, the value will be [-1].
  /// It will be unique across the layout.
  int get index => _index;

  DockingParentArea? _parent;

  /// Gets the parent of this area or [NULL] if it is the root.
  DockingParentArea? get parent => _parent;

  bool _disposed = false;

  /// Disposes recursively.
  void _dispose() {
    _parent = null;
    _layoutId = -1;
    _index = -1;
    _disposed = true;
  }

  /// Print used in debug.
  void _printDebug() {
    print(
        '$path - layoutIndex: $_index - id: $_id - layoutId: $_layoutId');
  }

  /// Gets the type of this area.
  DockingAreaType get type;

  /// Gets the acronym for type.
  String get typeAcronym {
    if (type == DockingAreaType.item) {
      return 'I';
    } else if (type == DockingAreaType.column) {
      return 'C';
    } else if (type == DockingAreaType.row) {
      return 'R';
    } else if (type == DockingAreaType.tabs) {
      return 'T';
    }
    throw StateError('DockingAreaType not recognized: ' + type.toString());
  }

  /// Gets the path in the layout hierarchy.
  String get path {
    String _path = typeAcronym;
    DockingParentArea? p = _parent;
    while (p != null) {
      _path = p.typeAcronym + _path;
      p = p._parent;
    }
    return _path;
  }

  /// Gets the level in the layout hierarchy.
  ///
  /// Return [0] if root (null parent).
  int get level {
    int l = 0;
    DockingParentArea? p = _parent;
    while (p != null) {
      l++;
      p = p._parent;
    }
    return l;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DockingArea &&
          runtimeType == other.runtimeType &&
          _index == other._index;

  @override
  int get hashCode => _index.hashCode;

  /// Updates recursively the information of parent, index and layoutId.
  int _updateHierarchy(
      DockingParentArea? parentArea, int nextIndex, int layoutId) {
    _parent = parentArea;
    _layoutId = layoutId;
    _index = nextIndex++;
    return nextIndex;
  }
}

/// Represents an abstract area for a collection of widgets.
abstract class DockingParentArea extends DockingArea {
  DockingParentArea(List<DockingArea> children) : this._children = children {
    for (DockingArea child in this._children) {
      if (child.runtimeType == this.runtimeType) {
        throw ArgumentError(
            'DockingParentArea cannot have children of the same type');
      }
    }
    if (this._children.length < 2) {
      throw ArgumentError('Insufficient number of children');
    }
  }

  final List<DockingArea> _children;

  /// Gets the count of children.
  int get childrenCount => _children.length;

  /// Gets a child for a given index.
  DockingArea childAt(int index) => _children[index];

  /// Whether the [DockingParentArea] contains a child equal to [area].
  bool contains(DockingArea area) {
    return _children.contains(area);
  }

  /// Applies the function [f] to each child of this collection in iteration
  /// order.
  void forEach(void f(DockingArea child)) {
    _children.forEach(f);
  }

  /// Applies the function [f] to each child of this collection in iteration
  /// reversed order.
  void forEachReversed(void f(DockingArea child)) {
    _children.reversed.forEach(f);
  }

  @override
  void _dispose() {
    super._dispose();
    for (DockingArea area in _children) {
      area._dispose();
    }
  }

  @override
  int _updateHierarchy(
      DockingParentArea? parentArea, int nextIndex, int layoutId) {
    _parent = parentArea;
    _layoutId = layoutId;
    _index = nextIndex++;
    for (DockingArea area in _children) {
      nextIndex = area._updateHierarchy(this, nextIndex, layoutId);
    }
    return nextIndex;
  }

  @override
  void _printDebug() {
    super._printDebug();
    for (DockingArea area in _children) {
      area._printDebug();
    }
  }
}

/// Represents an area for a single widget.
class DockingItem extends DockingArea with DropArea {
  /// Builds a [DockingItem].
  DockingItem({this.name, required this.widget});

  factory DockingItem._clone(DockingItem item) {
    return DockingItem(name: item.name, widget: item.widget);
  }

  final String? name;
  final Widget widget;

  bool _dragged = false;

  @override
  DockingAreaType get type => DockingAreaType.item;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged horizontally.
class DockingRow extends DockingParentArea {
  /// Builds a [DockingRow].
  DockingRow._(List<DockingArea> children) : super(children);

  /// Builds a [DockingRow].
  factory DockingRow(List<DockingArea> children) {
    List<DockingArea> newChildren = [];
    for (DockingArea child in children) {
      if (child is DockingRow) {
        newChildren.addAll(child._children);
      } else {
        newChildren.add(child);
      }
    }
    return DockingRow._(newChildren);
  }

  @override
  DockingAreaType get type => DockingAreaType.row;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends DockingParentArea {
  /// Builds a [DockingColumn].
  DockingColumn._(List<DockingArea> children) : super(children);

  /// Builds a [DockingColumn].
  factory DockingColumn(List<DockingArea> children) {
    List<DockingArea> newChildren = [];
    for (DockingArea child in children) {
      if (child is DockingColumn) {
        newChildren.addAll(child._children);
      } else {
        newChildren.add(child);
      }
    }
    return DockingColumn._(newChildren);
  }

  @override
  DockingAreaType get type => DockingAreaType.column;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged in tabs.
class DockingTabs extends DockingParentArea with DropArea {
  /// Builds a [DockingTabs].
  DockingTabs(List<DockingItem> children) : super(children);

  @override
  void forEach(void f(DockingItem child)) {
    _children.forEach((element) {
      f(element as DockingItem);
    });
  }

  @override
  DockingAreaType get type => DockingAreaType.tabs;
}

/// Represents the [DockingArea] type.
enum DockingAreaType { item, tabs, row, column }

/// Represents all positions available for a drop event that will
/// rearrange the layout.
enum DropPosition { top, bottom, left, right, center }

/// Represents a layout.
///
/// The layout is organized into [DockingItem], [DockingColumn],
/// [DockingRow] and [DockingTabs].
/// The [root] is single and can be any [DockingArea].
class DockingLayout {
  /// Builds a [DockingLayout].
  DockingLayout({DockingArea? root, int? id})
      : this._root = root,
        this.id = (id != null) ? id : DockingLayout._randomId() {
    _updateHierarchy();
  }

  /// The id of this layout.
  final int id;

  /// The protected root of this layout.
  DockingArea? _root;

  /// The root of this layout.
  DockingArea? get root => _root;

  /// Updates recursively the information of parent,
  /// index and layoutId in each [DockingArea].
  _updateHierarchy() {
    _root?._updateHierarchy(null, 1, id);
    // _root?._printDebug();
  }

  /// Throws error if [DockingArea] does not belong to this layout.
  void _validate(DockingArea area) {
    if (area._disposed) {
      throw ArgumentError('DockingArea already has been disposed.');
    }
    if (area.index == -1) {
      throw ArgumentError('DockingArea does not belong to this layout.');
    }
    if (area._layoutId != id) {
      throw ArgumentError(
          'DockingArea belongs to other layout. Keep the layout in the state of your StatefulWidget.');
    }
  }

  /// Rearranges the layout given a new location for a [DockingItem].
  void move(
      {required DockingItem draggedItem,
      required DropArea targetArea,
      required DropPosition dropPosition}) {
    if (draggedItem == targetArea) {
      throw ArgumentError(
          'Argument draggedItem cannot be the same as argument targetArea. A DockingItem cannot be rearranged on itself.');
    }
    _validate(draggedItem);
    if (!(targetArea is DockingArea)) {
      throw ArgumentError('Argument targetArea is not a DockingArea.');
    }
    _validate(targetArea as DockingArea);
    draggedItem._dragged = true;
    targetArea._layoutAction = _LaytoutAction(draggedItem, dropPosition);
    _rebuildLayout();
  }

  /// Removes a [DockingItem] from this layout.
  void remove(DockingItem item) {
    _remove(item, true);
  }

  /// Removes a [DockingItem] from this layout.
  void _remove(DockingItem item, bool simplify) {
    _validate(item);
    bool needUpdateLayout = false;
    if (item.parent == null) {
      // must be the root
      if (_root == item) {
        _root = null;
      } else {
        throw ArgumentError('DockingItem does not belong to this layout.');
      }
    } else {
      // is a child
      DockingParentArea parent = item.parent!;
      parent._children.remove(item);
      if (simplify) {
        needUpdateLayout = !_simplify(parent);
      }
    }
    item._dispose();
    if (needUpdateLayout) {
      _updateHierarchy();
    }
  }

  /// Replaces children in a [DockingParentArea].
  /// The layout index of each [DockingArea] will be updated.
  void _replaceChild(
      DockingParentArea parent, DockingArea oldChild, DockingArea newChild) {
    int index = parent._children.indexOf(oldChild);
    if (index == -1) {
      throw ArgumentError('The oldChild do not belong to this parent.');
    }
    if (newChild is DockingParentArea &&
        parent.runtimeType == newChild.runtimeType) {
      parent._children.remove(oldChild);
      newChild.forEachReversed((child) {
        parent._children.insert(index, child);
      });
      newChild._children.clear();
      newChild._dispose();
    } else {
      parent._children[index] = newChild;
    }
    oldChild._dispose();
    _updateHierarchy();
  }

  void _rebuildLayout() {
    if (_root != null) {
      _root = _rebuildLayoutRecursively(_root!);
      _updateHierarchy();
    }
  }

  DockingArea? _rebuildLayoutRecursively(DockingArea area) {
    if (area is DockingItem) {
      if (area._dragged && area._layoutAction != null) {
        throw StateError(
            'DockingItem is dragged and contains a layout action at same time.');
      } else if (area._dragged) {
        // ignore
        return null;
      } else if (area._layoutAction != null) {
        DockingItem draggedItem =
            DockingItem._clone(area._layoutAction!.draggedItem);
        DropPosition dropPosition = area._layoutAction!.dropPosition;
        if (dropPosition == DropPosition.center) {
          return DockingTabs([DockingItem._clone(area), draggedItem]);
        } else if (dropPosition == DropPosition.top) {
          return DockingColumn([draggedItem, DockingItem._clone(area)]);
        } else if (dropPosition == DropPosition.bottom) {
          return DockingColumn([DockingItem._clone(area), draggedItem]);
        } else if (dropPosition == DropPosition.left) {
          return DockingRow([draggedItem, DockingItem._clone(area)]);
        } else if (dropPosition == DropPosition.right) {
          return DockingRow([DockingItem._clone(area), draggedItem]);
        } else {
          throw ArgumentError(
              'DropPosition not recognized: ' + dropPosition.toString());
        }
      }
      return DockingItem._clone(area);
    } else if (area is DockingTabs) {
      List<DockingItem> children = [];
      area.forEach((child) {
        if (child._dragged == false) {
          children.add(DockingItem._clone(child));
        }
      });
      DockingArea? newArea;
      if (children.length == 1) {
        newArea = children.first;
      } else {
        newArea = DockingTabs(children);
      }
      if (area._layoutAction != null) {
        DockingItem draggedItem =
            DockingItem._clone(area._layoutAction!.draggedItem);
        DropPosition dropPosition = area._layoutAction!.dropPosition;
        if (dropPosition == DropPosition.center) {
          children.add(draggedItem);
          return DockingTabs(children);
        } else if (dropPosition == DropPosition.top) {
          return DockingColumn([draggedItem, newArea]);
        } else if (dropPosition == DropPosition.bottom) {
          return DockingColumn([newArea, draggedItem]);
        } else if (dropPosition == DropPosition.left) {
          return DockingRow([draggedItem, newArea]);
        } else if (dropPosition == DropPosition.right) {
          return DockingRow([newArea, draggedItem]);
        } else {
          throw ArgumentError(
              'DropPosition not recognized: ' + dropPosition.toString());
        }
      }
      return newArea;
    } else if (area is DockingParentArea) {
      List<DockingArea> children = [];
      area.forEach((child) {
        DockingArea? newChild = _rebuildLayoutRecursively(child);
        if (newChild != null) {
          children.add(newChild);
        }
      });
      if (children.length == 0) {
        return null;
      } else if (children.length == 1) {
        return children.first;
      }
      if (area is DockingRow) {
        return DockingRow(children);
      } else if (area is DockingColumn) {
        return DockingColumn(children);
      }
      throw StateError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw StateError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }

  /// Simplifies the layout, that is, if a parent has only 1 child,
  /// this parent will be replaced by the child.
  ///
  /// The return indicates whether the layout index of each [DockingArea]
  /// has been updated
  bool _simplify(DockingParentArea node) {
    if (node._children.length == 1) {
      DockingArea singleChild = node._children.removeAt(0);
      if (node.parent == null) {
        // must be the root
        if (_root == node) {
          _root = singleChild;
          node._dispose();
          _updateHierarchy();
        } else {
          throw ArgumentError(
              'DockingParentArea does not belong to this layout.');
        }
      } else {
        // is a child
        DockingParentArea parent = node.parent!;
        _replaceChild(parent, node, singleChild);
      }
      return true;
    }
    return false;
  }

  /// Gets a random id.
  static int _randomId() {
    return math.Random().nextInt(9999999) + 1;
  }
}
