import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name) {
  return DockingItem(name: name, widget: Container());
}

void testDockingItem(DockingArea item,
    {int? id, String? name, bool? hasParent, int? level}) {
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
}

void testOffstage(DockingArea area) {
  expect(area.id, -1, reason: 'id');
  expect(area.parent, isNull, reason: 'null parent');
  expect(area.level, -1, reason: 'level');
}
