import 'package:flutter/widgets.dart';

/// Represents any area of the layout.
///
/// It can be a single widget or a collection of widgets.
/// There are 3 types of collection: column, row and stack.
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

/// Indicates whether a class can have child areas
mixin _DockingCollectionArea {
  List<DockingArea> get children;

  bool _removeChild(DockingArea area);
}

/// Represents a single widget.
class DockingItem extends DockingArea {
  /// Builds a [DockingItem].
  DockingItem({this.name, required this.widget});

  final String? name;
  final Widget widget;
}

/// Represents a collection of widgets.
/// Children will be arranged horizontally.
class DockingRow extends DockingArea with _DockingCollectionArea {
  /// Builds a [DockingRow].
  DockingRow(this.children);

  @override
  final List<DockingArea> children;

  @override
  bool _removeChild(DockingArea area) {
    children.remove(area);
    if (children.length == 0) {
      if (parent != null && parent is _DockingCollectionArea) {
        return (parent as _DockingCollectionArea)._removeChild(this);
      }
      return true;
    }
    return false;
  }
}

/// Represents a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends DockingArea with _DockingCollectionArea {
  /// Builds a [DockingColumn].
  DockingColumn(this.children);

  @override
  final List<DockingArea> children;

  @override
  bool _removeChild(DockingArea area) {
    children.remove(area);
    if (children.length == 0) {
      if (parent != null && parent is _DockingCollectionArea) {
        return (parent as _DockingCollectionArea)._removeChild(this);
      }
      return true;
    }
    return false;
  }
}

/// Represents a collection of widgets.
/// Children will be arranged in tabs.
class DockingTabs extends DockingArea with _DockingCollectionArea {
  /// Builds a [DockingTabs].
  DockingTabs(this.children);

  @override
  final List<DockingItem> children;

  @override
  bool _removeChild(DockingArea area) {
    children.remove(area);
    if (children.length == 0) {
      if (parent != null && parent is _DockingCollectionArea) {
        return (parent as _DockingCollectionArea)._removeChild(this);
      }
      return true;
    }
    return false;
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
  _setIdsAndParents() {
    if (_root != null) {
      _setIdAndParent(null, _root!, 1);
    }
  }

  /// Sets the id and parent of a given area.
  int _setIdAndParent(DockingArea? parentArea, DockingArea area, int nextId) {
    area._id = nextId++;
    area._parent = parentArea;
    if (area is _DockingCollectionArea) {
      for (DockingArea child in (area as _DockingCollectionArea).children) {
        nextId = _setIdAndParent(area, child, nextId);
      }
    }
    return nextId;
  }

  /// Rearranges the layout given a new location for a [DockingItem].
  rearrange(
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

  _removeFromParent(DockingItem item) {
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

  _rearrangeOnCenter(
      {required DockingItem draggedItem, required DockingArea dropArea}) {
    if (dropArea is DockingItem) {
    } else if (dropArea is DockingTabs) {}
  }

  _rearrangeOnBottom(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  _rearrangeOnTop(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  _rearrangeOnLeft(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}

  _rearrangeOnRight(
      {required DockingItem draggedItem, required DockingArea dropArea}) {}
}
