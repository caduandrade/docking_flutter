import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name) {
  return DockingItem(name: name, widget: Container());
}

void testDockingArea(DockingArea area,
    {int? layoutIndex, bool? hasParent, int? level, String? path}) {
  if (layoutIndex != null) {
    expect(area.layoutIndex, layoutIndex, reason: 'layoutIndex');
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

void testDisposedDockingColumn(DockingColumn column) {
  testDockingParentArea(column,
      layoutIndex: -1, childrenCount: 0, hasParent: false, path: 'C', level: 0);
}

void testDisposedDockingRow(DockingRow row) {
  testDockingParentArea(row,
      layoutIndex: -1, childrenCount: 0, hasParent: false, path: 'R', level: 0);
}

void testDisposedDockingTabs(DockingTabs tabs) {
  testDockingParentArea(tabs,
      layoutIndex: -1, childrenCount: 0, hasParent: false, path: 'T', level: 0);
}

void testDisposedDockingItem(DockingItem item) {
  testDockingArea(item, layoutIndex: -1, hasParent: false, path: 'I', level: 0);
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

void testOffstage(DockingArea area) {
  expect(area.layoutIndex, -1, reason: 'index');
  expect(area.parent, isNull, reason: 'null parent');
  expect(area.level, 0, reason: 'level');
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
