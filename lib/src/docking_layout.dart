import 'package:flutter/widgets.dart';

/// Represents any area of the layout.
abstract class DockingArea {
  int _id = -1;

  /// Gets the id within the layout.
  ///
  /// If the area is outside the layout, the value will be [-1].
  int get id => _id;

  DockingParentArea? _parent;

  /// Gets the parent of this area or [NULL] if it is the root.
  DockingParentArea? get parent => _parent;

  /// Gets the type of this area.
  DockingAreaType get type;

  /// Gets the acronym for type.
  String get _typeAcronym {
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
    String _path = _typeAcronym;
    DockingParentArea? p = _parent;
    while (p != null) {
      _path = p._typeAcronym + _path;
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
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  /// Sets the id and parent of areas recursively in the hierarchy.
  int _updateIdAndParent(DockingParentArea? parentArea, int nextId) {
    _id = nextId++;
    _parent = parentArea;
    return nextId;
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

  void _addChild(DockingArea child) {
    //TODO e o id?
    //TODO verificar se veio de outro layout?
    _checkSameType(child);
    _children.add(child);
    child._parent = this;
  }

  void _replaceChild(DockingArea oldChild, DockingArea newChild) {
    //TODO verificar se veio de outro layout?
    int index = _children.indexOf(oldChild);
    if (index == -1) {
      throw ArgumentError('The oldChild do not belong to this parent.');
    }
    if (this.runtimeType == newChild.runtimeType) {
      (newChild as DockingParentArea).forEachReversed((child) {
        _children.insert(index, child);
        child._parent = this;
      });
      _children.remove(oldChild);
      newChild._parent = null;
      newChild._id = -1;
    } else {
      _children[index] = newChild;
      newChild._parent = this;
    }
    oldChild._parent = null;
    oldChild._id = -1;
  }

  @override
  int _updateIdAndParent(DockingParentArea? parentArea, int nextId) {
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
    _updateIdAndParent();
    _simplifyAll();
  }

  /// The protected root of this layout.
  DockingArea? _root;

  /// The root of this layout.
  DockingArea? get root => _root;

  /// Sets the id and parent of areas recursively in the hierarchy.
  void _updateIdAndParent() {
    _root?._updateIdAndParent(null, 1);
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

  /// Removes a [DockingItem] from this layout.
  void remove(DockingItem item) {
    //TODO dispose bool? esse com _ sem dispose
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
      _simplify(parent);
    }
    item._parent = null;
    item._id = -1;
  }

  _simplifyAll() {
    //TODO here!
  }

  _simplify(DockingParentArea node) {
    if (node._children.length == 1) {
      DockingArea singleChild = node._children.first;
      if (node.parent == null) {
        // must be the root
        if (_root == node) {
          _root = singleChild;
          singleChild._parent = null;
        } else {
          throw ArgumentError(
              'DockingParentArea does not belong to this layout.');
        }
      } else {
        // is a child
        DockingParentArea parent = node.parent!;
        parent._replaceChild(node, singleChild);
      }
    }
    node._parent = null;
    node._parent = null;
    node._id = -1;
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

  //TODO validar id de novas áreas? atualizar id?
}
