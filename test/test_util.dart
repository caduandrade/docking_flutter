import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name) {
  return DockingItem(name: name, widget: Container());
}

void testDockingItem(DockingArea area, int id, String? name, bool hasParent) {
  expect(area.type, DockingAreaType.item, reason: 'type');
  DockingItem item = area as DockingItem;
  expect(item.id, id, reason: 'id');
  expect(item.name, name, reason: 'name');
  expect(item.parent != null, hasParent, reason: 'hasParent');
}

void testOffstage(DockingArea area) {
  expect(area.id, -1, reason: 'id');
  expect(area.parent, isNull, reason: 'null parent');
}
