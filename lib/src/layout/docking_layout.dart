import 'package:docking/src/layout/add_item.dart';
import 'package:docking/src/layout/layout_modifier.dart';
import 'package:docking/src/layout/move_item.dart';
import 'package:docking/src/layout/remove_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

mixin DropArea {}

/// Represents any area of the layout.
abstract class DockingArea {
  DockingArea();

  int _layoutId = -1;

  int get layoutId => _layoutId;

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

  bool get disposed => _disposed;

  /// Disposes recursively.
  void _dispose() {
    _parent = null;
    _layoutId = -1;
    _index = -1;
    _disposed = true;
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

  /// Updates recursively the information of parent, index and layoutId.
  int _updateHierarchy(
      DockingParentArea? parentArea, int nextIndex, int layoutId) {
    if (this.disposed) {
      throw StateError('Disposed area');
    }
    _parent = parentArea;
    _layoutId = layoutId;
    _index = nextIndex++;
    return nextIndex;
  }

  String hierarchy(
      {bool indexInfo = false,
      bool levelInfo = false,
      bool hasParentInfo = false,
      bool nameInfo = false}) {
    String str = typeAcronym;
    if (indexInfo) {
      str += index.toString();
    }
    if (levelInfo) {
      str += level.toString();
    }
    if (hasParentInfo) {
      if (_parent == null) {
        str += 'F';
      } else {
        str += 'T';
      }
    }
    return str;
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
      if (child.disposed) {
        throw ArgumentError('DockingParentArea cannot have disposed child');
      }
      if (child.layoutId != -1) {
        throw ArgumentError('Child already belongs to another layout');
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
    if (this.disposed) {
      throw StateError('Disposed area');
    }
    _parent = parentArea;
    _layoutId = layoutId;
    _index = nextIndex++;
    for (DockingArea area in _children) {
      nextIndex = area._updateHierarchy(this, nextIndex, layoutId);
    }
    return nextIndex;
  }

  @override
  String hierarchy(
      {bool indexInfo = false,
      bool levelInfo = false,
      bool hasParentInfo = false,
      bool nameInfo = false}) {
    String str = super.hierarchy(
            indexInfo: indexInfo,
            levelInfo: levelInfo,
            hasParentInfo: hasParentInfo) +
        '(';
    for (int i = 0; i < _children.length; i++) {
      if (i > 0) {
        str += ',';
      }
      str += _children[i].hierarchy(
          levelInfo: levelInfo,
          hasParentInfo: hasParentInfo,
          indexInfo: indexInfo,
          nameInfo: nameInfo);
    }
    str += ')';
    return str;
  }
}

/// Represents an area for a single widget.
class DockingItem extends DockingArea with DropArea {
  /// Builds a [DockingItem].
  DockingItem({this.name, required this.widget});

  factory DockingItem.clone(DockingItem item) {
    return DockingItem(name: item.name, widget: item.widget);
  }

  final String? name;
  final Widget widget;

  @override
  DockingAreaType get type => DockingAreaType.item;

  @override
  String hierarchy(
      {bool indexInfo = false,
      bool levelInfo = false,
      bool hasParentInfo = false,
      bool nameInfo = false}) {
    String str = super.hierarchy(
        indexInfo: indexInfo,
        levelInfo: levelInfo,
        hasParentInfo: hasParentInfo,
        nameInfo: nameInfo);
    if (nameInfo && name != null) {
      str += name!;
    }
    return str;
  }
}

/// Represents an area for a collection of widgets.
/// Children will be arranged horizontally.
class DockingRow extends DockingParentArea {
  /// Builds a [DockingRow].
  DockingRow._(List<DockingArea> children) : super(children);

  List<double> weights = [];

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

  List<double> weights = [];

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

  int selectedIndex = 0;

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
class DockingLayout extends ChangeNotifier {
  /// Builds a [DockingLayout].
  DockingLayout({DockingArea? root}) : this._root = root {
    _updateHierarchy();
  }

  /// The id of this layout.
  int get id => this.hashCode;

  /// The protected root of this layout.
  DockingArea? _root;

  /// The root of this layout.
  DockingArea? get root => _root;

  /// Converts layout's hierarchical structure to String.
  String hierarchy(
      {bool indexInfo = false,
      bool levelInfo = false,
      bool hasParentInfo = false,
      bool nameInfo = false}) {
    if (_root == null) {
      return '';
    }
    return _root!.hierarchy(
        indexInfo: indexInfo,
        levelInfo: levelInfo,
        hasParentInfo: hasParentInfo,
        nameInfo: nameInfo);
  }

  /// Updates recursively the information of parent,
  /// index and layoutId in each [DockingArea].
  _updateHierarchy() {
    _root?._updateHierarchy(null, 1, id);
  }

  /// Moves a DockingItem in this layout.
  void moveItem(
      {required DockingItem draggedItem,
      required DropArea targetArea,
      required DropPosition dropPosition}) {
    _rebuild(MoveItem(
        draggedItem: draggedItem,
        targetArea: targetArea,
        dropPosition: dropPosition));
  }

  /// Removes a DockingItem from this layout.
  void removeItem({required DockingItem item}) {
    _rebuild(RemoveItem(itemToRemove: item));
  }

  /// Adds a DockingItem to this layout.
  void addItemOn(
      {required DockingItem newItem,
      required DropArea targetArea,
      required DropPosition dropPosition}) {
    _rebuild(AddItem(
        newItem: newItem, targetArea: targetArea, dropPosition: dropPosition));
  }

  /// Adds a DockingItem to the root of this layout.
  void addItemOnRoot(
      {required DockingItem newItem, required DropPosition dropPosition}) {
    if (root == null) {
      throw StateError('Root is null');
    }
    if (root is DropArea) {
      DropArea targetArea = root! as DropArea;
      _rebuild(AddItem(
          newItem: newItem,
          targetArea: targetArea,
          dropPosition: dropPosition));
    } else {
      throw StateError('Root is not a DropArea');
    }
  }

  /// Rebuilds this layout with a modifier.
  void _rebuild(LayoutModifier modifier) {
    List<DockingArea> toDispose = layoutAreas();
    _root = modifier.newLayout(this);
    _updateHierarchy();
    toDispose.forEach((area) => area._dispose());
    notifyListeners();
  }

  /// Gets all [DockingArea] from this layout.
  List<DockingArea> layoutAreas() {
    List<DockingArea> list = [];
    if (_root != null) {
      _fetchAreas(list, _root!);
    }
    return list;
  }

  /// Gets recursively all [DockingArea] of that layout.
  void _fetchAreas(List<DockingArea> areas, DockingArea root) {
    areas.add(root);
    if (root is DockingParentArea) {
      DockingParentArea parentArea = root;
      parentArea.forEach((child) => _fetchAreas(areas, child));
    }
  }
}
