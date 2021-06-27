import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents any area of the layout.
abstract class DockingArea {
  int _layoutIndex = -1;

  /// Gets the index in the layout.
  ///
  /// If the area is outside the layout, the value will be [-1].
  /// It will be unique across the layout.
  int get layoutIndex => _layoutIndex;

  DockingParentArea? _parent;

  void _dispose() {
    _parent = null;
    _layoutIndex = -1;
  }

  /// Gets the parent of this area or [NULL] if it is the root.
  DockingParentArea? get parent => _parent;

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
          _layoutIndex == other._layoutIndex;

  @override
  int get hashCode => _layoutIndex.hashCode;

  /// Sets the parent of areas recursively in the hierarchy.
  void _updateParent(DockingParentArea? parentArea) {
    _parent = parentArea;
  }

  @override
  int _updateLayoutIndex(int nextIndex) {
    _layoutIndex = nextIndex++;
    return nextIndex;
  }
}

/// Represents an abstract area for a collection of widgets.
abstract class DockingParentArea extends DockingArea {
  DockingParentArea(List<DockingArea> children) : this._children = children {
    for (DockingArea child in this._children) {
      _checkSameType(child);
    }
    if (this._children.length < 2) {
      throw ArgumentError('Insufficient number of children');
    }
    //TODO verificar se veio de outro layout?
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

  void _checkSameType(DockingArea child) {
    if (child.runtimeType == this.runtimeType) {
      throw ArgumentError(
          'DockingParentArea cannot have children of the same type');
    }
  }

  @override
  void _updateParent(DockingParentArea? parentArea) {
    super._updateParent(parentArea);
    for (DockingArea area in _children) {
      area._updateParent(this);
    }
  }

  @override
  int _updateLayoutIndex(int nextIndex) {
    _layoutIndex = nextIndex++;
    for (DockingArea area in _children) {
      nextIndex = area._updateLayoutIndex(nextIndex);
    }
    return nextIndex;
  }
}

/// Represents an area for a single widget.
class DockingItem extends DockingArea {
  /// Builds a [DockingItem].
  DockingItem({this.name, required this.widget});

  final String? name;
  final Widget widget;

  @override
  DockingAreaType get type => DockingAreaType.item;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged horizontally.
class DockingRow extends DockingParentArea {
  /// Builds a [DockingRow].
  DockingRow(List<DockingArea> children) : super(children);

  @override
  DockingAreaType get type => DockingAreaType.row;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends DockingParentArea {
  /// Builds a [DockingColumn].
  DockingColumn(List<DockingArea> children) : super(children);

  @override
  DockingAreaType get type => DockingAreaType.column;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged in tabs.
class DockingTabs extends DockingParentArea {
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
/// There must be a single root that can be any [DockingArea].
class DockingLayout {
  /// Builds a [DockingLayout].
  DockingLayout({DockingArea? root}) : this._root = root {
    _updateLayoutIndexAndParent();
  }

  /// The protected root of this layout.
  DockingArea? _root;

  /// The root of this layout.
  DockingArea? get root => _root;

  /// Updates the layout index and parent of each [DockingArea].
  _updateLayoutIndexAndParent() {
    _root?._updateParent(null);
    _root?._updateLayoutIndex(1);
  }

  /// Indicates whether the [DockingArea] belongs to this layout.
  bool _contains(DockingArea area) {
    return true;
  }

  /// Throws error if [DockingArea] does not belong to this layout.
  void _validade(DockingArea area) {
    if (_contains(area) == false) {
      throw ArgumentError('DockingArea does not belong to this layout.');
    }
  }

  /// Rearranges the layout given a new location for a [DockingItem].
  void move(
      {required DockingItem draggedItem,
      required DockingArea dropArea,
      required DropPosition dropPosition}) {
    if (draggedItem == dropArea) {
      throw ArgumentError(
          'Argument draggedItem cannot be the same as argument dropArea. A DockingItem cannot be rearranged on itself.');
    }
    remove(draggedItem);
    _validade(dropArea);
    switch (dropPosition) {
      case DropPosition.center:
        _rearrangeOnCenter(draggedItem: draggedItem, dropArea: dropArea);
        break;
      case DropPosition.bottom:
        _rearrangeOnBottom(draggedItem: draggedItem, dropArea: dropArea);
        break;
      case DropPosition.top:
        _rearrangeOnTop(draggedItem: draggedItem, dropArea: dropArea);
        break;
      case DropPosition.left:
        _rearrangeOnLeft(draggedItem: draggedItem, dropArea: dropArea);
        break;
      case DropPosition.right:
        _rearrangeOnRight(draggedItem: draggedItem, dropArea: dropArea);
        break;
    }
    _updateLayoutIndexAndParent();
  }

  /// Removes a [DockingItem] from this layout.
  void remove(DockingItem item) {
    _validade(item);
    bool needUpdataLayout = false;
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
      needUpdataLayout = !_simplify(parent);
    }
    item._dispose();
    if (needUpdataLayout) {
      _updateLayoutIndexAndParent();
    }
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
        //TODO verificar se pertence ao layout?
        if (_root == node) {
          _root = singleChild;
          node._dispose();
          _updateLayoutIndexAndParent();
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

  /// Replaces children in a [DockingParentArea].
  /// The layout index of each [DockingArea] will be updated.
  void _replaceChild(
      DockingParentArea parent, DockingArea oldChild, DockingArea newChild) {
    //TODO verificar se veio de outro layout?
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
    _updateLayoutIndexAndParent();
  }

  void _rearrangeOnCenter(
      {required DockingItem draggedItem, required DockingArea dropArea}) {
    if (dropArea is DockingItem) {
      DockingItem targetItem = dropArea;
      DockingTabs tabs = DockingTabs([targetItem, draggedItem]);
      if (_root == targetItem) {
        _root = tabs;
      } else {
        DockingParentArea targetParent = targetItem.parent!;
        _replaceChild(targetParent, targetItem, tabs);
      }
    } else if (dropArea is DockingTabs) {
      DockingTabs tabs = dropArea;
      tabs._children.add(draggedItem);
    }
  }

  void _rearrangeOnBottom(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  void _rearrangeOnTop(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  void _rearrangeOnLeft(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  void _rearrangeOnRight(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  //TODO validar id de novas áreas? atualizar id?
}
