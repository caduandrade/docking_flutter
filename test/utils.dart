import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name, {dynamic id}) {
  return DockingItem(id: id, name: name, widget: Container());
}

void removeItemById(DockingLayout layout, List<dynamic> ids) {
  List<DockingItem> itemsToDispose = [];
  for (dynamic id in ids) {
    DockingItem? item = layout.findDockingItem(id);
    if (item != null) {
      itemsToDispose.add(item);
    }
  }
  List<DockingArea> areas = layout.layoutAreas();
  layout.removeItemByIds(ids);
  areas.forEach((area) {
    bool areaIsDisposedItem = false;
    for (DockingItem disposedItem in itemsToDispose) {
      if (area == disposedItem) {
        areaIsDisposedItem = true;
        break;
      }
    }
    if (area is DockingItem && !areaIsDisposedItem) {
      testNonDisposedArea(area);
    } else {
      testDisposed(area);
    }
  });
}

void removeItem(DockingLayout layout, DockingItem item) {
  List<DockingArea> areas = layout.layoutAreas();
  layout.removeItem(item: item);
  testOldAreas(areas, disposedItem: item);
}

void moveItem(DockingLayout layout, DockingItem draggedItem,
    DropArea targetArea, DropPosition dropPosition) {
  List<DockingArea> areas = layout.layoutAreas();
  layout.moveItem(
      draggedItem: draggedItem,
      targetArea: targetArea,
      dropPosition: dropPosition);
  testOldAreas(areas);
}

void addItemOnRoot(
    DockingLayout layout, DockingItem newItem, DropPosition dropPosition) {
  List<DockingArea> areas = layout.layoutAreas();
  layout.addItemOnRoot(newItem: newItem, dropPosition: dropPosition);
  testOldAreas(areas);
}

void addItemOn(DockingLayout layout, DockingItem newItem, DropArea targetArea,
    DropPosition dropPosition) {
  List<DockingArea> areas = layout.layoutAreas();
  layout.addItemOn(
      newItem: newItem, targetArea: targetArea, dropPosition: dropPosition);
  testOldAreas(areas);
}

int _testAreasAttributes(DockingArea parent, bool value, int level, int index) {
  expect(parent.parent != null, value);
  expect(parent.level, level);
  expect(parent.index, index);
  index++;
  if (parent is DockingParentArea) {
    parent.forEach((child) {
      index = _testAreasAttributes(child, true, level + 1, index);
    });
  }
  return index;
}

void testAreasAttributes(DockingLayout layout) {
  if (layout.root != null) {
    _testAreasAttributes(layout.root!, false, 0, 1);
  }
}

void testHierarchy(DockingLayout layout, String hierarchy) {
  if (hierarchy.length == 0) {
    expect(layout.root, isNull);
  } else {
    expect(layout.root, isNotNull);
    testAreasAttributes(layout);
    expect(layout.hierarchy(nameInfo: true), hierarchy);
  }
}

void testNonDisposedArea(DockingArea area) {
  expect(area.layoutId > -1, true, reason: 'has layoutId');
  expect(area.index > -1, true, reason: 'has index');
}

void testOldAreas(List<DockingArea> layoutAreas, {DockingItem? disposedItem}) {
  layoutAreas.forEach((area) {
    if (area is DockingItem && area != disposedItem) {
      testNonDisposedArea(area);
    } else {
      testDisposed(area);
    }
  });
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
