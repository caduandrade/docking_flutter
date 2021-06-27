import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils.dart';

void main() {
  group('remove', () {
    test('item', () {
      DockingItem item = dockingItem('a');
      DockingLayout layout = DockingLayout(root: item);
      layout.remove(item);
      expect(layout.root, isNull);
      testOffstage(item);
    });

    test('item out from layout', () {
      DockingLayout layout = DockingLayout();
      expect(() => layout.remove(dockingItem('a')), throwsArgumentError);
      layout = DockingLayout(root: dockingItem('a'));
      expect(() => layout.remove(dockingItem('a')), throwsArgumentError);
    });

    test('row item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingRow row = DockingRow([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: row);

      testDockingParentArea(row,
          layoutIndex: 1,
          childrenCount: 3,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'RI', level: 1);
      testDockingItem(itemB,
          layoutIndex: 3, name: 'b', hasParent: true, path: 'RI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 4, name: 'c', hasParent: true, path: 'RI', level: 1);

      layout.remove(itemA);

      expect(layout.root, row);
      testDockingParentArea(row,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: -1, name: 'a', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemB,
          layoutIndex: 2, name: 'b', hasParent: true, path: 'RI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 3, name: 'c', hasParent: true, path: 'RI', level: 1);

      layout.remove(itemB);

      testDockingParentArea(row,
          layoutIndex: -1,
          childrenCount: 0,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemB,
          layoutIndex: -1, name: 'b', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemC,
          layoutIndex: 1, name: 'c', hasParent: false, path: 'I', level: 0);
      expect(layout.root!, itemC);
    });

    test('column item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingColumn column = DockingColumn([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testDockingParentArea(column,
          layoutIndex: 1,
          childrenCount: 3,
          hasParent: false,
          path: 'C',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'CI', level: 1);
      testDockingItem(itemB,
          layoutIndex: 3, name: 'b', hasParent: true, path: 'CI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 4, name: 'c', hasParent: true, path: 'CI', level: 1);

      layout.remove(itemA);

      expect(layout.root, column);
      testDockingParentArea(column,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'C',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: -1, name: 'a', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemB,
          layoutIndex: 2, name: 'b', hasParent: true, path: 'CI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 3, name: 'c', hasParent: true, path: 'CI', level: 1);

      layout.remove(itemB);

      testDockingParentArea(column,
          layoutIndex: -1,
          childrenCount: 0,
          hasParent: false,
          path: 'C',
          level: 0);
      testDockingItem(itemB,
          layoutIndex: -1, name: 'b', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemC,
          layoutIndex: 1, name: 'c', hasParent: false, path: 'I', level: 0);
      expect(layout.root!, itemC);
    });

    test('tabs item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingTabs tabs = DockingTabs([itemA, itemB, itemC]);
      DockingLayout layout = DockingLayout(root: tabs);

      testDockingParentArea(tabs,
          layoutIndex: 1,
          childrenCount: 3,
          hasParent: false,
          path: 'T',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'TI', level: 1);
      testDockingItem(itemB,
          layoutIndex: 3, name: 'b', hasParent: true, path: 'TI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 4, name: 'c', hasParent: true, path: 'TI', level: 1);

      layout.remove(itemA);

      expect(layout.root, tabs);
      testDockingParentArea(tabs,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'T',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: -1, name: 'a', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemB,
          layoutIndex: 2, name: 'b', hasParent: true, path: 'TI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 3, name: 'c', hasParent: true, path: 'TI', level: 1);

      layout.remove(itemB);

      testDockingParentArea(tabs,
          layoutIndex: -1,
          childrenCount: 0,
          hasParent: false,
          path: 'T',
          level: 0);
      testDockingItem(itemB,
          layoutIndex: -1, name: 'b', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemC,
          layoutIndex: 1, name: 'c', hasParent: false, path: 'I', level: 0);
      expect(layout.root!, itemC);
    });

    test('column row item 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingColumn column = DockingColumn([row, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testDockingParentArea(column,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'C',
          level: 0);
      testDockingParentArea(row,
          layoutIndex: 2,
          childrenCount: 2,
          hasParent: true,
          path: 'CR',
          level: 1);
      testDockingItem(itemA,
          layoutIndex: 3, name: 'a', hasParent: true, path: 'CRI', level: 2);
      testDockingItem(itemB,
          layoutIndex: 4, name: 'b', hasParent: true, path: 'CRI', level: 2);
      testDockingItem(itemC,
          layoutIndex: 5, name: 'c', hasParent: true, path: 'CI', level: 1);

      layout.remove(itemC);

      testDockingParentArea(column,
          layoutIndex: -1,
          childrenCount: 0,
          hasParent: false,
          path: 'C',
          level: 0);
      testDockingParentArea(row,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'RI', level: 1);
      testDockingItem(itemB,
          layoutIndex: 3, name: 'b', hasParent: true, path: 'RI', level: 1);
      testDockingItem(itemC,
          layoutIndex: -1, name: 'c', hasParent: false, path: 'I', level: 0);
      expect(layout.root, row);

      layout.remove(itemB);

      testDockingParentArea(row,
          layoutIndex: -1,
          childrenCount: 0,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 1, name: 'a', hasParent: false, path: 'I', level: 0);
      testDockingItem(itemB,
          layoutIndex: -1, name: 'b', hasParent: false, path: 'I', level: 0);
      expect(layout.root, itemA);
    });

    test('column row item 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingColumn column = DockingColumn([row, itemC]);
      DockingLayout layout = DockingLayout(root: column);

      testDockingParentArea(column,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'C',
          level: 0);
      testDockingParentArea(row,
          layoutIndex: 2,
          childrenCount: 2,
          hasParent: true,
          path: 'CR',
          level: 1);
      testDockingItem(itemA,
          layoutIndex: 3, name: 'a', hasParent: true, path: 'CRI', level: 2);
      testDockingItem(itemB,
          layoutIndex: 4, name: 'b', hasParent: true, path: 'CRI', level: 2);
      testDockingItem(itemC,
          layoutIndex: 5, name: 'c', hasParent: true, path: 'CI', level: 1);

      layout.remove(itemA);

      testDockingParentArea(column,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'C',
          level: 0);
      testDisposedDockingRow(row);
      testDisposedDockingItem(itemA);
      testDockingItem(itemB,
          layoutIndex: 2, name: 'b', hasParent: true, path: 'CI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 3, name: 'c', hasParent: true, path: 'CI', level: 1);
      expect(layout.root, column);

      layout.remove(itemB);

      testDisposedDockingColumn(column);
      testDisposedDockingItem(itemB);
      testDockingItem(itemC,
          layoutIndex: 1, name: 'c', hasParent: false, path: 'I', level: 0);
      expect(layout.root, itemC);
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

      testDockingParentArea(rootRow,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'RI', level: 1);
      testDockingParentArea(column,
          layoutIndex: 3,
          childrenCount: 2,
          hasParent: true,
          path: 'RC',
          level: 1);
      testDockingParentArea(row,
          layoutIndex: 4,
          childrenCount: 2,
          hasParent: true,
          path: 'RCR',
          level: 2);
      testDockingItem(itemB,
          layoutIndex: 5, name: 'b', hasParent: true, path: 'RCRI', level: 3);
      testDockingItem(itemC,
          layoutIndex: 6, name: 'c', hasParent: true, path: 'RCRI', level: 3);
      testDockingItem(itemD,
          layoutIndex: 7, name: 'd', hasParent: true, path: 'RCI', level: 2);

      layout.remove(itemD);

      testDockingParentArea(rootRow,
          layoutIndex: 1,
          childrenCount: 3,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'RI', level: 1);
      testDisposedDockingColumn(column);
      testDisposedDockingRow(row);
      testDockingItem(itemB,
          layoutIndex: 3, name: 'b', hasParent: true, path: 'RI', level: 1);
      testDockingItem(itemC,
          layoutIndex: 4, name: 'c', hasParent: true, path: 'RI', level: 1);
      testDisposedDockingItem(itemD);
      expect(layout.root, rootRow);

      layout.remove(itemB);

      testDockingParentArea(rootRow,
          layoutIndex: 1,
          childrenCount: 2,
          hasParent: false,
          path: 'R',
          level: 0);
      testDockingItem(itemA,
          layoutIndex: 2, name: 'a', hasParent: true, path: 'RI', level: 1);
      testDisposedDockingItem(itemB);
      testDockingItem(itemC,
          layoutIndex: 3, name: 'c', hasParent: true, path: 'RI', level: 1);
      testDisposedDockingItem(itemD);
      expect(layout.root, rootRow);

      layout.remove(itemC);

      testDockingParentArea(rootRow);
      testDockingItem(itemA,
          layoutIndex: 1, name: 'a', hasParent: false, path: 'I', level: 0);
      testDisposedDockingItem(itemB);
      testDisposedDockingItem(itemC);
      testDisposedDockingItem(itemD);
      expect(layout.root, itemA);
    });
  });
}
