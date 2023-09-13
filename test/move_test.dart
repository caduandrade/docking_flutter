import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

void main() {
  group('move item - exceptions', () {
    test('draggedItem == targetArea ', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      expect(() => moveItemToPosition(layout, item, item, DropPosition.bottom),
          sameDraggedItemAndTargetAreaException());
    });

    test('nested tabbed panel - 0', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      expect(
          () => moveItemToIndex(layout, itemA, itemB, 0), throwsArgumentError);
    });

    test('nested tabbed panel - 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      expect(
          () => moveItemToIndex(layout, itemA, itemB, 1), throwsArgumentError);
    });
  });

  group('move item', () {
    test('row - no change', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToPosition(layout, itemA, itemB, DropPosition.left);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('row - invert', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToPosition(layout, itemA, itemB, DropPosition.right);

      testHierarchy(layout, 'R(Ib,Ia)');
    });

    test('row - to column 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToPosition(layout, itemA, itemB, DropPosition.top);

      testHierarchy(layout, 'C(Ia,Ib)');
    });

    test('row - to column 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToPosition(layout, itemA, itemB, DropPosition.bottom);

      testHierarchy(layout, 'C(Ib,Ia)');
    });

    test('row - to tabs 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToIndex(layout, itemA, itemB, 0);

      testHierarchy(layout, 'T(Ia,Ib)');
    });

    test('row - to tabs 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToIndex(layout, itemA, itemB, 1);

      testHierarchy(layout, 'T(Ib,Ia)');
    });

    test('row - to tabs 3', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToIndex(layout, itemA, tabs, 0);

      testHierarchy(layout, 'T(Ia,Ib,Ic)');
    });

    test('row - to tabs 4', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToIndex(layout, itemA, tabs, 1);

      testHierarchy(layout, 'T(Ib,Ia,Ic)');
    });

    test('row - to tabs 5', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingRow row = DockingRow([itemA, tabs]);
      DockingLayout layout = DockingLayout(root: row);

      moveItemToIndex(layout, itemA, tabs, 2);

      testHierarchy(layout, 'T(Ib,Ic,Ia)');
    });

    test('complex 1 a', () {
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

      moveItemToIndex(layout, itemA, itemC, 0);

      testHierarchy(layout, 'C(Ib,T(Ia,Ic),T(Id,Ie))');
    });

    test('complex 1 b', () {
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

      moveItemToIndex(layout, itemA, itemC, 1);

      testHierarchy(layout, 'C(Ib,T(Ic,Ia),T(Id,Ie))');
    });

    test('complex 2 a', () {
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

      moveItemToIndex(layout, itemA, itemC, 0);

      testHierarchy(layout, 'C(Ib,T(Ia,Ic),T(Id,Ie),If)');
    });

    test('complex 2 b', () {
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

      moveItemToIndex(layout, itemA, itemC, 1);

      testHierarchy(layout, 'C(Ib,T(Ic,Ia),T(Id,Ie),If)');
    });

    test('complex 3 a', () {
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

      moveItemToIndex(layout, itemA, itemC, 0);

      testHierarchy(layout, 'R(Ig,C(Ib,T(Ia,Ic),T(Id,Ie),If))');
    });

    test('complex 3 b', () {
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

      moveItemToIndex(layout, itemA, itemC, 1);

      testHierarchy(layout, 'R(Ig,C(Ib,T(Ic,Ia),T(Id,Ie),If))');
    });

    test('complex 3 c', () {
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

      moveItemToIndex(layout, itemB, tabs, 1);

      testHierarchy(layout, 'R(Ig,C(R(Ia,Ic),T(Id,Ib,Ie),If))');
    });
  });
}
