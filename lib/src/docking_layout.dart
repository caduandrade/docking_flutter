import 'package:flutter/widgets.dart';

/// Represents any area of the layout.
class DockingArea {
  int _id = 0;
  DockingArea? _parent;

  /// Gets the id.
  int get id => _id;

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
}

/// Represents an abstract area for a collection of widgets.
abstract class _DockingCollectionArea extends DockingArea {
  _DockingCollectionArea(List<DockingArea> children)
      : this._children = children;

  final List<DockingArea> _children;

  int get childrenCount => _children.length;

  void forEach(void f(DockingArea child)) {
    _children.forEach(f);
  }

  bool _removeChild(DockingArea area) {
    _children.remove(area);
    if (_children.length == 0) {
      if (parent != null && parent is _DockingCollectionArea) {
        return (parent as _DockingCollectionArea)._removeChild(this);
      }
      return true;
    }
    return false;
  }
}

/// Represents an area for a single widget.
class DockingItem extends DockingArea {
  /// Builds a [DockingItem].
  DockingItem({this.name, required this.widget});

  final String? name;
  final Widget widget;
}

/// Represents an area for a collection of widgets.
/// Children will be arranged horizontally.
class DockingRow extends _DockingCollectionArea {
  /// Builds a [DockingRow].
  DockingRow(List<DockingArea> children) : super(children);
}

/// Represents an area for a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends _DockingCollectionArea {
  /// Builds a [DockingColumn].
  DockingColumn(List<DockingArea> children) : super(children);
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
}

/// Represents all positions available for a drop event that will
/// rearrange the layout.
enum DropPosition { top, bottom, left, right, center }

/// Represents a layout.
///
/// There must be a single root that can be any [DockingArea].
class DockingLayout {
  /// Builds a [DockingLayout].
  DockingLayout(DockingArea? root) : this._root = root {
    _setIdsAndParents();
  }

  /// The protected root of this layout.
  DockingArea? _root;

  /// The root of this layout.
  DockingArea? get root => _root;

  /// Sets the id and parent of the areas.
  void _setIdsAndParents() {
    if (_root != null) {
      _setIdAndParent(null, _root!, 1);
    }
  }

  /// Sets the id and parent of a given area.
  int _setIdAndParent(DockingArea? parentArea, DockingArea area, int nextId) {
    area._id = nextId++;
    area._parent = parentArea;
    if (area is _DockingCollectionArea) {
      area.forEach((child) {
        nextId = _setIdAndParent(area, child, nextId);
      });
    }
    return nextId;
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
      _root = null;
    } else if (item.parent is _DockingCollectionArea) {
      if ((item.parent as _DockingCollectionArea)._removeChild(item)) {
        _root = null;
      }
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
