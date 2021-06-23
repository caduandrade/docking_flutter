import 'package:flutter/widgets.dart';

class DockingArea {
  int _id = 0;
  DockingArea? _parent;

  int get id => _id;

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

mixin _DockingParentArea {
  List<DockingArea> get children;
}

class DockingItem extends DockingArea {
  DockingItem({this.name, required this.widget});

  final String? name;
  final Widget widget;
}

class DockingRow extends DockingArea with _DockingParentArea {
  DockingRow(this.children);

  @override
  final List<DockingArea> children;
}

class DockingColumn extends DockingArea with _DockingParentArea {
  DockingColumn(this.children);

  @override
  final List<DockingArea> children;
}

class DockingTabs extends DockingArea with _DockingParentArea {
  DockingTabs(this.children);

  @override
  final List<DockingItem> children;
}

class DockingLayout {
  DockingLayout(this.root) {
    _initialize(null, this.root);
  }

  final DockingArea root;
  int _nextId = 1;

  _initialize(DockingArea? parentArea, DockingArea area) {
    area._id = _nextId++;
    area._parent = parentArea;
    if (area is _DockingParentArea) {
      for (DockingArea child in (area as _DockingParentArea).children) {
        _initialize(area, child);
      }
    }
  }
}
