import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

void main() {
  group('add item - exceptions', () {
    test('dropItem == targetArea', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      expect(() => addItemOnRootPosition(layout, item, DropPosition.left),
          sameDraggedItemAndTargetAreaException());
    });

    test('area.layoutId != -1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);
      expect(() => addItemOn(layout, itemB, itemA, DropPosition.right),
          dockingAreaInSomeLayoutException());
    });
  });

  group('add item', () {
    test('item on root - left', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.left);
      testHierarchy(layout, 'R(Ib,Ia)');
    });

    test('item on root - right', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.right);
      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('item on root - top', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.top);
      testHierarchy(layout, 'C(Ib,Ia)');
    });

    test('item on root - bottom', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.bottom);
      testHierarchy(layout, 'C(Ia,Ib)');
    });

    test('item on root - index 0', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      addItemOnRootIndex(layout, dockingItem('b'), 0);
      testHierarchy(layout, 'T(Ib,Ia)');
    });

    test('item on root - index 1', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      addItemOnRootIndex(layout, dockingItem('b'), 1);
      testHierarchy(layout, 'T(Ia,Ib)');
    });

    test('item on row - right', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);
      addItemOn(layout, dockingItem('c'), itemA, DropPosition.right);
      testHierarchy(layout, 'R(Ia,Ic,Ib)');
    });
  });
}
