import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('remove item by id', () {
    test('item', () {
      DockingItem item = dockingItem('a', id: 1);
      DockingLayout layout = DockingLayout(root: item);
      testHierarchy(layout, 'Ia');
      removeItemById(layout, [1]);
      testHierarchy(layout, '');
    });

    test('empty layout', () {
      DockingLayout layout = DockingLayout();
      removeItemById(layout, [1]);
      testHierarchy(layout, '');
    });

    test('row item 1', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingRow row = DockingRow([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row item 2', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'Ib');
    });

    test('column item 1', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingColumn column = DockingColumn([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib,Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('column item 2', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingColumn column = DockingColumn([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 1', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingTabs tabs = DockingTabs([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib,Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'T(Ib,Ic)');
    });

    test('tabs item 2', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingTabs tabs = DockingTabs([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 3', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingTabs tabs = DockingTabs([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItemById(layout, [1, 2]);

      testHierarchy(layout, '');
    });

    test('column row item 1', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingRow row = DockingRow([itemA, itemB]);
      DockingColumn column = DockingColumn([row, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItemById(layout, [3]);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('column row item 2', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingRow row = DockingRow([itemA, itemB]);
      DockingColumn column = DockingColumn([row, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('row column row item', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingItem itemD = dockingItem('d', id: 4);
      DockingRow row = DockingRow([itemB, itemC]);
      DockingColumn column = DockingColumn([row, itemD]);
      DockingRow rootRow = DockingRow([itemA, column]);
      DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');

      removeItemById(layout, [4]);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');
    });

    test('row column row item (2)', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingItem itemD = dockingItem('d', id: 4);
      DockingRow row = DockingRow([itemB, itemC]);
      DockingColumn column = DockingColumn([row, itemD]);
      DockingRow rootRow = DockingRow([itemA, column]);
      DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, [1, 4]);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row column row item (3)', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingItem itemD = dockingItem('d', id: 4);
      DockingRow row = DockingRow([itemB, itemC]);
      DockingColumn column = DockingColumn([row, itemD]);
      DockingRow rootRow = DockingRow([itemA, column]);
      DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, [1, 3]);

      testHierarchy(layout, 'C(Ib,Id)');
    });

    test('row column row item (4)', () {
      DockingItem itemA = dockingItem('a', id: 1);
      DockingItem itemB = dockingItem('b', id: 2);
      DockingItem itemC = dockingItem('c', id: 3);
      DockingItem itemD = dockingItem('d', id: 4);
      DockingRow row = DockingRow([itemB, itemC]);
      DockingColumn column = DockingColumn([row, itemD]);
      DockingRow rootRow = DockingRow([itemA, column]);
      DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, [1, 2, 3]);

      testHierarchy(layout, 'Id');
    });
  });
}
