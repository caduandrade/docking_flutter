import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name) {
  return DockingItem(name: name, widget: Container());
}

void testDockingItem(DockingArea item,
    {int? id, String? name, bool? hasParent, int? level, String? path}) {
  expect(item.type, DockingAreaType.item, reason: 'type');
  DockingItem _item = item as DockingItem;

  if (id != null) {
    expect(_item.id, id, reason: 'id');
  }

  expect(_item.name, name, reason: 'name');

  if (hasParent != null) {
    expect(_item.parent != null, hasParent, reason: 'hasParent');
  }

  if (level != null) {
    expect(_item.level, level, reason: 'level');
  }

  if (path != null) {
    expect(_item.path, path, reason: 'path');
  }
}

void testOffstage(DockingArea area) {
  expect(area.id, -1, reason: 'id');
  expect(area.parent, isNull, reason: 'null parent');
  expect(area.level, 0, reason: 'level');
}

DockingRow rootRow(DockingLayout layout) {
  expect(layout.root, isNotNull);
  expect(layout.root!.type, DockingAreaType.row);
  return layout.root as DockingRow;
}

DockingColumn rootColumn(DockingLayout layout) {
  expect(layout.root, isNotNull);
  expect(layout.root!.type, DockingAreaType.column);
  return layout.root as DockingColumn;
}

DockingTabs rootTabs(DockingLayout layout) {
  expect(layout.root, isNotNull);
  expect(layout.root!.type, DockingAreaType.tabs);
  return layout.root as DockingTabs;
}
