import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('move item', () {
    test('draggedItem == targetArea ', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      expect(() => moveItem(layout, item, item, DropPosition.bottom),
          throwsArgumentError);
    });

    test('row - no change', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItem(layout, itemA, itemB, DropPosition.left);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('row - invert', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItem(layout, itemA, itemB, DropPosition.right);

      testHierarchy(layout, 'R(Ib,Ia)');
    });

    test('row - to column 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItem(layout, itemA, itemB, DropPosition.top);

      testHierarchy(layout, 'C(Ia,Ib)');
    });

    test('row - to column 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItem(layout, itemA, itemB, DropPosition.bottom);

      testHierarchy(layout, 'C(Ib,Ia)');
    });

    test('row - to tabs 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItem(layout, itemA, itemB, DropPosition.center);

      testHierarchy(layout, 'T(Ib,Ia)');
    });

    test('row - to tabs 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      moveItem(layout, itemA, tabs, DropPosition.center);

      testHierarchy(layout, 'T(Ib,Ic,Ia)');
    });

    test('nested tabbed panel', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      expect(() => moveItem(layout, itemA, itemB, DropPosition.center),
          throwsArgumentError);
    });

    test('complex 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingColumn innerColumn = DockingColumn([itemB, itemC]);
      DockingRow row = DockingRow([itemA, innerColumn]);
      DockingTabs tabs = DockingTabs([itemD, itemE]);
      DockingColumn column = DockingColumn([row, tabs]);
      DockingLayout layout = DockingLayout(root: column);

      moveItem(layout, itemA, itemC, DropPosition.center);

      testHierarchy(layout, 'C(Ib,T(Ic,Ia),T(Id,Ie))');
    });

    test('complex 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingItem itemF = dockingItem('f');
      DockingColumn innerColumn = DockingColumn([itemB, itemC]);
      DockingRow row = DockingRow([itemA, innerColumn]);
      DockingTabs tabs = DockingTabs([itemD, itemE]);
      DockingColumn column = DockingColumn([row, tabs, itemF]);
      DockingLayout layout = DockingLayout(root: column);

      moveItem(layout, itemA, itemC, DropPosition.center);

      testHierarchy(layout, 'C(Ib,T(Ic,Ia),T(Id,Ie),If)');
    });

    test('complex 3', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingItem itemF = dockingItem('f');
      DockingItem itemG = dockingItem('g');
      DockingColumn innerColumn = DockingColumn([itemB, itemC]);
      DockingRow row = DockingRow([itemA, innerColumn]);
      DockingTabs tabs = DockingTabs([itemD, itemE]);
      DockingColumn column = DockingColumn([row, tabs, itemF]);
      DockingRow row2 = DockingRow([itemG, column]);
      DockingLayout layout = DockingLayout(root: row2);

      moveItem(layout, itemA, itemC, DropPosition.center);

      testHierarchy(layout, 'R(Ig,C(Ib,T(Ic,Ia),T(Id,Ie),If))');
    });
  });
}
