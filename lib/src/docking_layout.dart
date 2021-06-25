import 'package:flutter/widgets.dart';

/// Represents any area of the layout.
abstract class DockingArea {
  int _id = 0;
  DockingArea? _parent;

  /// Gets the id.
  int get id => _id;

  /// Gets the type of this area.
  DockingAreaType get type;

  /// Gets the parent of this area or [NULL] if it is the root.
  DockingArea? get parent => _parent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DockingArea &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  /// Sets the id and parent of areas recursively in the hierarchy.
  int _updateIdAndParent(DockingArea? parentArea, int nextId) {
    _id = nextId++;
    _parent = parentArea;
    return nextId;
  }
}

class _DockingRoot extends DockingArea {
  _DockingRoot(DockingArea? child) : this._child = child;

  DockingArea? _child;

  DockingArea? get child => _child;

  _removeChild(DockingArea child) {
    child._parent = null;
    _child = null;
  }

  void _replaceChild(DockingArea oldChild, DockingArea newChild) {
    _child = newChild;
    newChild._parent = this;
    oldChild._parent = null;
  }

  @override
  int _updateIdAndParent(DockingArea? parentArea, int nextId) {
    nextId = super._updateIdAndParent(parentArea, nextId);
    _child?._updateIdAndParent(this, nextId);
    return nextId;
  }

  @override
  DockingAreaType get type => DockingAreaType.root;
}

/// Represents an abstract area for a collection of widgets.
abstract class _DockingCollectionArea extends DockingArea {
  _DockingCollectionArea(List<DockingArea> children)
      : this._children = children;

  final List<DockingArea> _children;

  /// Gets the count of children.
  int get childrenCount => _children.length;

  /// Applies the function [f] to each child of this collection in iteration
  /// order.
  void forEach(void f(DockingArea child)) {
    _children.forEach(f);
  }

  void _addChild(DockingArea child) {
    _children.add(child);
    child._parent = this;
  }

  void _replaceChild(DockingArea oldChild, DockingArea newChild) {
    int index = _children.indexOf(oldChild);
    if (index == -1) {
      //TODO error
    }
    _children.add(newChild);
    newChild._parent = this;
    oldChild._parent = null;
    _children.remove(oldChild);
  }

  /// Removes a child from this collection.
  ///
  /// The return indicates if this collection is an empty layout root.
  void _removeChild(DockingArea child) {
    child._parent = null;
    _children.remove(child);
    if (_children.length == 0) {
      if (parent == null) {
        throw StateError('_DockingCollectionArea parent should not be null.');
      } else {
        if (parent is _DockingCollectionArea) {
          (parent as _DockingCollectionArea)._removeChild(this);
        } else if (parent is _DockingRoot) {
          (parent as _DockingRoot)._removeChild(this);
        } else {
          //TODO tipo não reconhecido
        }
      }
    } else if (_children.length == 1) {
      DockingArea lastChild = _children.first;
      if (parent == null) {
        throw StateError('_DockingCollectionArea parent should not be null.');
      } else {
        if (parent is _DockingCollectionArea) {
          (parent as _DockingCollectionArea)._replaceChild(this, lastChild);
        } else if (parent is _DockingRoot) {
          (parent as _DockingRoot)._replaceChild(this, lastChild);
        } else {
          //TODO tipo não reconhecido
        }
      }
    }
  }

  @override
  int _updateIdAndParent(DockingArea? parentArea, int nextId) {
    _id = nextId++;
    _parent = parentArea;
    for (DockingArea area in _children) {
      nextId = area._updateIdAndParent(this, nextId);
    }
    return nextId;
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
class DockingRow extends _DockingCollectionArea {
  /// Builds a [DockingRow].
  DockingRow(List<DockingArea> children) : super(children);

  @override
  DockingAreaType get type => DockingAreaType.row;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends _DockingCollectionArea {
  /// Builds a [DockingColumn].
  DockingColumn(List<DockingArea> children) : super(children);

  @override
  DockingAreaType get type => DockingAreaType.column;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged in tabs.
class DockingTabs extends _DockingCollectionArea {
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
enum DockingAreaType { root, item, tabs, row, column }

/// Represents all positions available for a drop event that will
/// rearrange the layout.
enum DropPosition { top, bottom, left, right, center }

/// Represents a layout.
///
/// There must be a single root that can be any [DockingArea].
class DockingLayout {
  /// Builds a [DockingLayout].
  DockingLayout({DockingArea? root}) : this._root = _DockingRoot(root) {
    _updateIdAndParent();
  }

  /// The protected root of this layout.
  _DockingRoot _root;

  /// The root of this layout.
  DockingArea? get root => _root.child;

  /// Sets the id and parent of areas recursively in the hierarchy.
  void _updateIdAndParent() {
    _root._updateIdAndParent(null, 0);
  }

  /// Rearranges the layout given a new location for a [DockingItem].
  void rearrange(
      {required DockingItem draggedItem,
      required DockingArea dropArea,
      required DropPosition dropPosition}) {
    if (draggedItem == dropArea) {
      throw ArgumentError(
          'Argument draggedItem cannot be the same as argument dropArea. A DockingItem cannot be rearranged on itself.');
    }
    _removeFromParent(draggedItem);
    print(draggedItem.id.toString() +
        ' on ' +
        dropArea.id.toString() +
        ' / ' +
        dropPosition.toString());
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
  }

  void _removeFromParent(DockingItem item) {
    if (item.parent == null) {
      throw StateError('DockingItem parent should not be null.');
    } else if (item.parent is _DockingRoot) {
      (item as _DockingRoot)._removeChild(item);
    } else if (item.parent is _DockingCollectionArea) {
      (item.parent as _DockingCollectionArea)._removeChild(item);
    } else {
      throw ArgumentError(
          'It is not possible to remove DockingItem from its parent.');
    }
  }

  void _rearrangeOnCenter(
      {required DockingItem draggedItem, required DockingArea dropArea}) {
    if (dropArea is DockingItem) {
    } else if (dropArea is DockingTabs) {}
  }

  void _rearrangeOnBottom(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  void _rearrangeOnTop(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  void _rearrangeOnLeft(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  void _rearrangeOnRight(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}
}
