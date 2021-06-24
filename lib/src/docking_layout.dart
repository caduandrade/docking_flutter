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
}

/// Represents a collection of widgets.
/// Children will be arranged vertically.
class DockingColumn extends DockingArea with _DockingCollectionArea {
  /// Builds a [DockingColumn].
  DockingColumn(this.children);

  @override
  final List<DockingArea> children;
}

/// Represents a collection of widgets.
/// Children will be arranged in tabs.
class DockingTabs extends DockingArea with _DockingCollectionArea {
  /// Builds a [DockingTabs].
  DockingTabs(this.children);

  @override
  final List<DockingItem> children;
}

/// Represents a layout.
///
/// There must be a single root that can be any [DockingArea].
class DockingLayout {
  /// Builds a [DockingLayout].
  DockingLayout(this.root) {
    _initialize(null, this.root);
  }

  /// The root of this layout
  final DockingArea root;

  int _nextId = 1;

  /// Initialize the ids and parents data for each area.
  _initialize(DockingArea? parentArea, DockingArea area) {
    area._id = _nextId++;
    area._parent = parentArea;
    if (area is _DockingCollectionArea) {
      for (DockingArea child in (area as _DockingCollectionArea).children) {
        _initialize(area, child);
      }
    }
  }
}
