import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_util.dart';

void main() {
  group('default id and parent', () {
    test('item', () {
      DockingLayout layout = DockingLayout(root: dockingItem('a'));
      expect(layout.root, isNotNull);
      testDockingItem(layout.root!,
          id: 1, name: 'a', hasParent: false, path: 'I');
    });

    test('row', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingLayout layout = DockingLayout(root: DockingRow([itemA, itemB]));
      DockingRow row = rootRow(layout);
      expect(row.childrenCount, 2);
      testDockingItem(row.childAt(0),
          id: 2, name: 'a', hasParent: true, path: 'RI');
      expect(row.childAt(0), itemA);
      testDockingItem(row.childAt(1),
          id: 3, name: 'b', hasParent: true, path: 'RI');
      expect(row.childAt(1), itemB);
    });

    test('column', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingLayout layout = DockingLayout(root: DockingColumn([itemA, itemB]));
      DockingColumn column = rootColumn(layout);
      expect(column.childrenCount, 2);
      testDockingItem(column.childAt(0), id: 2, name: 'a', hasParent: true);
      expect(column.childAt(0), itemA);
      testDockingItem(column.childAt(1), id: 3, name: 'b', hasParent: true);
      expect(column.childAt(1), itemB);
    });
  });

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
      DockingLayout layout =
          DockingLayout(root: DockingRow([itemA, itemB, itemC]));
      testDockingItem(itemA, id: 2, name: 'a', hasParent: true, path: 'RI');
      testDockingItem(itemB, id: 3, name: 'b', hasParent: true, path: 'RI');
      testDockingItem(itemC, id: 4, name: 'c', hasParent: true, path: 'RI');
      layout.remove(itemA);
      DockingRow row = rootRow(layout);
      expect(row.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!, id: 4, name: 'c', hasParent: false);
      //testDockingItem(itemC,id: 2, name:'c',hasParent: false, path: 'RI');
      //expect(layout.root!, itemC);
    });

    test('column item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout =
          DockingLayout(root: DockingColumn([itemA, itemB, itemC]));
      testDockingItem(itemA, id: 2, name: 'a', hasParent: true, path: 'CI');
      testDockingItem(itemB, id: 3, name: 'b', hasParent: true, path: 'CI');
      testDockingItem(itemC, id: 4, name: 'c', hasParent: true, path: 'CI');
      layout.remove(itemA);
      DockingColumn column = rootColumn(layout);
      expect(column.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!, id: 4, name: 'c', hasParent: false);
      //testDockingItem(itemC,id: 2, name:'c',hasParent: false, path: 'CI');
      //expect(layout.root!, itemC);
    });

    test('tabs item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout =
          DockingLayout(root: DockingTabs([itemA, itemB, itemC]));
      testDockingItem(itemA, id: 2, name: 'a', hasParent: true, path: 'TI');
      testDockingItem(itemB, id: 3, name: 'b', hasParent: true, path: 'TI');
      testDockingItem(itemC, id: 4, name: 'c', hasParent: true, path: 'TI');
      layout.remove(itemA);
      DockingTabs tabs = rootTabs(layout);
      expect(tabs.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!, id: 4, name: 'c', hasParent: false);
      //testDockingItem(itemC,id: 2, name:'c',hasParent: false, path: 'TI');
      //expect(layout.root!, itemC);
    });

    test('column row item 1', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout = DockingLayout(
          root: DockingColumn([
        DockingRow([itemA, itemB]),
        itemC
      ]));
      testDockingItem(itemA, id: 3, name: 'a', hasParent: true, path: 'CRI');
      testDockingItem(itemB, id: 4, name: 'b', hasParent: true, path: 'CRI');
      testDockingItem(itemC, id: 5, name: 'c', hasParent: true, path: 'CI');
      layout.remove(itemC);
      DockingRow row = rootRow(layout);
      expect(row.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(itemA, id: 3, name: 'a', hasParent: false, path: 'I');
      //testDockingItem(itemA,id: 1, name:'a',hasParent: false, path:'I');
      //expect(layout.root!, itemA);
    });

    test('column row item 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout = DockingLayout(
          root: DockingColumn([
        DockingRow([itemA, itemB]),
        itemC
      ]));
      testDockingItem(itemA, id: 3, name: 'a', hasParent: true, path: 'CRI');
      testDockingItem(itemB, id: 4, name: 'b', hasParent: true, path: 'CRI');
      testDockingItem(itemC, id: 5, name: 'c', hasParent: true, path: 'CI');
      layout.remove(itemA);
      DockingColumn column = rootColumn(layout);
      expect(column.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(itemC, id: 5, name: 'c', hasParent: false, path: 'I');
      //testDockingItem(itemC,id: 1, name:'c',hasParent: false, path:'I');
      //expect(layout.root!, itemC);
    });

    test('row column row item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingLayout layout = DockingLayout(
          root: DockingRow([
        itemA,
        DockingColumn([
          DockingRow([itemB, itemC]),
          itemD
        ])
      ]));
      testDockingItem(itemA, id: 2, name: 'a', hasParent: true, path: 'RI');
      testDockingItem(itemB, id: 5, name: 'b', hasParent: true, path: 'RCRI');
      testDockingItem(itemC, id: 6, name: 'c', hasParent: true, path: 'RCRI');
      testDockingItem(itemD, id: 7, name: 'd', hasParent: true, path: 'RCI');
      layout.remove(itemD);
      testDockingItem(itemD, id: -1, name: 'd', hasParent: false, path: 'I');
      DockingRow row = rootRow(layout);
      expect(row.childrenCount, 3);
      testDockingItem(row.childAt(0),
          id: 2, name: 'a', hasParent: true, path: 'RI');
      expect(row.childAt(0), itemA);
      testDockingItem(row.childAt(1),
          id: 5, name: 'b', hasParent: true, path: 'RI');
      expect(row.childAt(1), itemB);
      testDockingItem(row.childAt(2),
          id: 6, name: 'c', hasParent: true, path: 'RI');
      expect(row.childAt(2), itemC);
      layout.remove(itemB);
      testDockingItem(itemB, id: -1, name: 'b', hasParent: false, path: 'I');
      expect(row.childrenCount, 2);
      testDockingItem(row.childAt(0),
          id: 2, name: 'a', hasParent: true, path: 'RI');
      expect(row.childAt(0), itemA);
      testDockingItem(row.childAt(1),
          id: 6, name: 'c', hasParent: true, path: 'RI');
      expect(row.childAt(1), itemC);
      layout.remove(itemC);
      testDockingItem(itemC, id: -1, name: 'c', hasParent: false, path: 'I');
      testDockingItem(layout.root!,
          id: 2, name: 'a', hasParent: false, path: 'I');
      expect(layout.root!, itemA);
    });
  });
}
