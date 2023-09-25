import 'package:docking/src/internal/layout/add_item.dart';
import 'package:docking/src/internal/layout/layout_modifier.dart';
import 'package:docking/src/internal/layout/move_item.dart';
import 'package:docking/src/internal/layout/remove_item.dart';
import 'package:docking/src/internal/layout/remove_item_by_id.dart';
import 'package:docking/src/layout/docking_area_type.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:tabbed_view/tabbed_view.dart';

mixin DropArea {}

/// Represents any area of the layout.
abstract class DockingArea extends Area {
  DockingArea(
      {double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize})
      : super(
            size: size,
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize);

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

  /// Disposes.
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
    if (_layoutId != -1 && _layoutId != layoutId) {
      throw ArgumentError(
          'DockingParentArea already belongs to another layout');
    }
    _layoutId = layoutId;
    _index = nextIndex++;
    return nextIndex;
  }

  /// Converts layout's hierarchical structure to a debug String.
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

  String get areaAcronym;
}

/// Represents an abstract area for a collection of widgets.
abstract class DockingParentArea extends DockingArea {
  DockingParentArea(List<DockingArea> children,
      {double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize})
      : this._children = children,
        super(
            size: size,
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize) {
    for (DockingArea child in this._children) {
      if (child.runtimeType == this.runtimeType) {
        throw ArgumentError(
            'DockingParentArea cannot have children of the same type');
      }
      if (child.disposed) {
        throw ArgumentError('DockingParentArea cannot have disposed child');
      }
    }
  }

  final List<DockingArea> _children;

  /// Gets the count of children.
  int get childrenCount => _children.length;

  /// Gets a child for a given index.
  DockingArea childAt(int index) => _children[index];

  /// The first index of [dockingArea] in this container.
  ///
  /// Returns -1 if [dockingArea] is not found.
  int indexOf(DockingArea dockingArea) => _children.indexOf(dockingArea);

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
  int _updateHierarchy(
      DockingParentArea? parentArea, int nextIndex, int layoutId) {
    if (this.disposed) {
      throw StateError('Disposed area');
    }
    _parent = parentArea;
    if (_layoutId != -1 && _layoutId != layoutId) {
      throw ArgumentError(
          'DockingParentArea already belongs to another layout');
    }
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
/// The [keepAlive] parameter keeps the state during the layout change.
/// The default value is [FALSE]. This feature implies using GlobalKeys and
/// keeping the widget in memory even if its tab is not selected.
class DockingItem extends DockingArea with DropArea {
  /// Builds a [DockingItem].
  DockingItem(
      {this.id,
      this.name,
      required this.widget,
      this.value,
      this.closable = true,
      bool keepAlive = false,
      List<TabButton>? buttons,
      this.maximizable,
      bool maximized = false,
      this.leading,
      double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize})
      : this.buttons = buttons != null ? List.unmodifiable(buttons) : [],
        this.globalKey = keepAlive ? GlobalKey() : null,
        this._maximized = maximized,
        super(
            size: size,
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize);

  final dynamic id;
  String? name;
  Widget widget;
  dynamic value;
  bool closable;
  final bool? maximizable;
  List<TabButton>? buttons;
  final GlobalKey? globalKey;
  TabLeadingBuilder? leading;
  bool _maximized;

  bool get maximized => _maximized;

  @override
  DockingAreaType get type => DockingAreaType.item;

  /// Reset parent and index in layout.
  void _resetLocationInLayout() {
    _parent = null;
    _index = -1;
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
        hasParentInfo: hasParentInfo,
        nameInfo: nameInfo);
    if (nameInfo && name != null) {
      str += name!;
    }
    return str;
  }

  @override
  String get areaAcronym => 'I';
}

/// Represents an area for a collection of widgets.
/// Children will be arranged horizontally.
class DockingRow extends DockingParentArea {
  /// Builds a [DockingRow].
  DockingRow._(List<DockingArea> children,
      {double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize})
      : super(children,
            size: size,
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize) {
    controller = MultiSplitViewController(areas: children);
    if (this._children.length < 2) {
      throw ArgumentError('Insufficient number of children');
    }
  }

  /// Builds a [DockingRow].
  factory DockingRow(List<DockingArea> children,
      {double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize}) {
    List<DockingArea> newChildren = [];
    for (DockingArea child in children) {
      if (child is DockingRow) {
        newChildren.addAll(child._children);
      } else {
        newChildren.add(child);
      }
    }
    return DockingRow._(newChildren,
        size: size,
        weight: weight,
        minimalWeight: minimalWeight,
        minimalSize: minimalSize);
  }

  late MultiSplitViewController controller;

  @override
  DockingAreaType get type => DockingAreaType.row;

  @override
  String get areaAcronym => 'R';
}

/// Represents an area for a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends DockingParentArea {
  /// Builds a [DockingColumn].
  DockingColumn._(List<DockingArea> children,
      {double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize})
      : super(children,
            size: size,
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize) {
    controller = MultiSplitViewController(areas: children);
    if (this._children.length < 2) {
      throw ArgumentError('Insufficient number of children');
    }
  }

  /// Builds a [DockingColumn].
  factory DockingColumn(List<DockingArea> children,
      {double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize}) {
    List<DockingArea> newChildren = [];
    for (DockingArea child in children) {
      if (child is DockingColumn) {
        newChildren.addAll(child._children);
      } else {
        newChildren.add(child);
      }
    }
    return DockingColumn._(newChildren,
        size: size,
        weight: weight,
        minimalWeight: minimalWeight,
        minimalSize: minimalSize);
  }

  late MultiSplitViewController controller;

  @override
  DockingAreaType get type => DockingAreaType.column;

  @override
  String get areaAcronym => 'C';
}

/// Represents an area for a collection of widgets.
/// Children will be arranged in tabs.
class DockingTabs extends DockingParentArea with DropArea {
  /// Builds a [DockingTabs].
  DockingTabs(List<DockingItem> children,
      {bool maximized = false,
      this.maximizable,
      double? size,
      double? weight,
      double? minimalWeight,
      double? minimalSize})
      : this._maximized = maximized,
        super(children,
            size: size,
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize) {
    if (this._children.length == 0) {
      throw ArgumentError('DockingTabs cannot be empty');
    }
  }

  final bool? maximizable;

  int selectedIndex = 0;
  bool _maximized;

  bool get maximized => _maximized;

  @override
  DockingItem childAt(int index) => _children[index] as DockingItem;

  @override
  void forEach(void f(DockingItem child)) {
    _children.forEach((element) {
      f(element as DockingItem);
    });
  }

  @override
  DockingAreaType get type => DockingAreaType.tabs;

  @override
  String get areaAcronym => 'T';
}

/// Represents a layout.
///
/// The layout is organized into [DockingItem], [DockingColumn],
/// [DockingRow] and [DockingTabs].
/// The [root] is single and can be any [DockingArea].
class DockingLayout extends ChangeNotifier {
  /// Builds a [DockingLayout].
  DockingLayout({DockingArea? root}) : this._root = root {
    _reset();
  }

  /// The id of this layout.
  int get id => this.hashCode;

  /// The protected root of this layout.
  DockingArea? _root;

  /// The root of this layout.
  DockingArea? get root => _root;

  /// Set a new root.
  set root(DockingArea? root) {
    _root = root;
    _reset();
    notifyListeners();
  }

  /// Notifies the UI to rebuild the layout.
  void rebuild() {
    notifyListeners();
  }

  void _reset() {
    _updateHierarchy();
    int maximizedCount = 0;
    layoutAreas().forEach((area) {
      if (area is DockingItem && area.maximized) {
        maximizedCount++;
        _maximizedArea = area;
      } else if (area is DockingTabs && area.maximized) {
        maximizedCount++;
        _maximizedArea = area;
      }
    });
    if (maximizedCount > 1) {
      throw ArgumentError('Multiple maximized areas.');
    }
  }

  /// Holds a fast reference to the maximized area.
  DockingArea? _maximizedArea;

  /// Gets the maximized area in this layout.
  DockingArea? get maximizedArea => _maximizedArea;

  /// Converts layout's hierarchical structure to a debug String.
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

  /// Finds a [DockingItem] given an id.
  DockingItem? findDockingItem(dynamic id) {
    return _findDockingItem(parent: root, id: id);
  }

  /// Recursively finds a [DockingItem] given an id.
  DockingItem? _findDockingItem({DockingArea? parent, dynamic id}) {
    if (parent != null) {
      if (parent is DockingItem && parent.id == id) {
        return parent;
      } else if (parent is DockingParentArea) {
        for (DockingArea child in parent._children) {
          DockingItem? item = _findDockingItem(parent: child, id: id);
          if (item != null) {
            return item;
          }
        }
      }
    }
    return null;
  }

  /// Maximize a [DockingItem].
  void maximizeDockingItem(DockingItem dockingItem) {
    if (dockingItem.layoutId != id) {
      throw ArgumentError('DockingItem does not belong to this layout.');
    }
    if (dockingItem.maximized == false) {
      _removesMaximizedStatus();
      dockingItem._maximized = true;
      _maximizedArea = dockingItem;
      notifyListeners();
    }
  }

  /// Maximize a [DockingTabs].
  void maximizeDockingTabs(DockingTabs dockingTabs) {
    if (dockingTabs.layoutId != id) {
      throw ArgumentError('DockingTabs does not belong to this layout.');
    }
    if (dockingTabs.maximized == false) {
      _removesMaximizedStatus();
      dockingTabs._maximized = true;
      _maximizedArea = dockingTabs;
      notifyListeners();
    }
  }

  /// Removes maximized status from areas.
  void _removesMaximizedStatus() {
    layoutAreas().forEach((area) {
      if (area is DockingItem) {
        area._maximized = false;
      } else if (area is DockingTabs) {
        area._maximized = false;
      }
    });
    _maximizedArea = null;
  }

  /// Removes any maximize status.
  void restore() {
    _removesMaximizedStatus();
    notifyListeners();
  }

  /// Moves a DockingItem in this layout.
  void moveItem(
      {required DockingItem draggedItem,
      required DropArea targetArea,
      DropPosition? dropPosition,
      int? dropIndex}) {
    //TODO maximize test
    _rebuild([
      MoveItem(
          draggedItem: draggedItem,
          targetArea: targetArea,
          dropPosition: dropPosition,
          dropIndex: dropIndex)
    ]);
  }

  /// Removes multiple DockingItem by id from this layout.
  void removeItemByIds(List<dynamic> ids) {
    List<LayoutModifier> modifiers = [];
    for (dynamic id in ids) {
      modifiers.add(RemoveItemById(id: id));
    }
    _rebuild(modifiers);
  }

  /// Removes a DockingItem from this layout.
  void removeItem({required DockingItem item}) {
    _rebuild([RemoveItem(itemToRemove: item)]);
  }

  /// Adds a DockingItem to this layout.
  void addItemOn(
      {required DockingItem newItem,
      required DropArea targetArea,
      DropPosition? dropPosition,
      int? dropIndex}) {
    //TODO maximize test
    _rebuild([
      AddItem(
          newItem: newItem,
          targetArea: targetArea,
          dropPosition: dropPosition,
          dropIndex: dropIndex)
    ]);
  }

  /// Adds a DockingItem to the root of this layout.
  void addItemOnRoot(
      {required DockingItem newItem,
      DropPosition? dropPosition,
      int? dropIndex}) {
    if (root == null) {
      throw StateError('Root is null');
    }
    if (root is DropArea) {
      DropArea targetArea = root! as DropArea;
      _rebuild([
        AddItem(
            newItem: newItem,
            targetArea: targetArea,
            dropPosition: dropPosition,
            dropIndex: dropIndex)
      ]);
    } else {
      throw StateError('Root is not a DropArea');
    }
    //TODO maximize test
  }

  /// Rebuilds this layout with modifiers.
  void _rebuild(List<LayoutModifier> modifiers) {
    List<DockingArea> olderAreas = layoutAreas();

    for (LayoutModifier modifier in modifiers) {
      layoutAreas().forEach((area) {
        if (area is DockingItem) {
          area._resetLocationInLayout();
        }
      });

      _root = modifier.newLayout(this);
      _updateHierarchy();

      olderAreas.forEach((area) {
        if (area is DockingParentArea) {
          area._dispose();
        } else if (area is DockingItem) {
          if (area.index == -1) {
            area._dispose();
          }
        }
      });
    }
    _maximizedArea = null;
    layoutAreas().forEach((area) {
      if (area is DockingItem && area.maximized) {
        _maximizedArea = area;
      } else if (area is DockingTabs && area.maximized) {
        _maximizedArea = area;
      }
    });

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
