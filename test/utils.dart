import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name) {
  return DockingItem(name: name, widget: Container());
}

void testDockingArea(DockingArea area,
    {int? layoutIndex, bool? hasParent, int? level, String? path}) {
  if (layoutIndex != null) {
    expect(area.index, layoutIndex, reason: 'layoutIndex');
  }
  if (hasParent != null) {
    expect(area.parent != null, hasParent, reason: 'hasParent');
  }
  if (level != null) {
    expect(area.level, level, reason: 'level');
  }

  if (path != null) {
    expect(area.path, path, reason: 'path');
  }
}

void testDisposed(DockingArea area) {
  testDockingArea(area,
      layoutIndex: -1, hasParent: false, path: area.typeAcronym, level: 0);
}

void testDockingParentArea(DockingParentArea parent,
    {int? layoutIndex,
    int? childrenCount,
    bool? hasParent,
    int? level,
    String? path}) {
  testDockingArea(parent,
      layoutIndex: layoutIndex, hasParent: hasParent, level: level, path: path);
  if (childrenCount != null) {
    expect(parent.childrenCount, childrenCount, reason: 'childrenCount');
  }
}

void testDockingItem(DockingArea item,
    {int? layoutIndex,
    String? name,
    bool? hasParent,
    int? level,
    String? path}) {
  testDockingArea(item,
      layoutIndex: layoutIndex, hasParent: hasParent, level: level, path: path);
  expect(item.type, DockingAreaType.item, reason: 'type');
  DockingItem _item = item as DockingItem;
  expect(_item.name, name, reason: 'name');
}

DockingRow rootAsRow(DockingLayout layout) {
  expect(layout.root, isNotNull);
  expect(layout.root!.type, DockingAreaType.row);
  return layout.root as DockingRow;
}

DockingColumn rootAsColumn(DockingLayout layout) {
  expect(layout.root, isNotNull);
  expect(layout.root!.type, DockingAreaType.column);
  return layout.root as DockingColumn;
}

DockingTabs rootAsTabs(DockingLayout layout) {
  expect(layout.root, isNotNull);
  expect(layout.root!.type, DockingAreaType.tabs);
  return layout.root as DockingTabs;
}
