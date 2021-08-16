import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('remove item', () {
    test('item', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      testHierarchy(layout, 'Ia');
      removeItem(layout, item);
      testHierarchy(layout, '');
    });

    test('item without layout', () {
      DockingLayout layout = DockingLayout();
      expect(() => removeItem(layout, dockingItem('a')), throwsArgumentError);
      layout = DockingLayout(root: dockingItem('a'));
      expect(() => removeItem(layout, dockingItem('b')), throwsArgumentError);
    });

    test('item from another layout', () {
      DockingLayout layout1 = DockingLayout(root: dockingItem('a'));
      DockingLayout layout2 = DockingLayout(root: dockingItem('b'));
      expect(
          () => removeItem(layout2, layout1.layoutAreas().first as DockingItem),
          throwsArgumentError);
    });

    test('row item 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingRow row = DockingRow([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row item 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'Ib');
    });

    test('column item 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingColumn column = DockingColumn([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib,Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('column item 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingColumn column = DockingColumn([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib,Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'T(Ib,Ic)');
    });

    test('tabs item 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingTabs tabs = DockingTabs([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'Ib');
    });

    test('column row item 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingColumn column = DockingColumn([row, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItem(layout, itemC);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('column row item 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingColumn column = DockingColumn([row, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('row column row item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingRow row = DockingRow([itemB, itemC]);
      DockingColumn column = DockingColumn([row, itemD]);
      DockingRow rootRow = DockingRow([itemA, column]);
      DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');

      removeItem(layout, itemD);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');
    });
  });
}
