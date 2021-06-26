import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_util.dart';

void main() {
  group('default id and parent', () {
    test('item', () {
      DockingLayout layout = DockingLayout(root: dockingItem('a'));

      expect(layout.root, isNotNull);
      testDockingItem(layout.root!, id:1, name:'a', hasParent: false);
    });

    test('row', () {
      DockingLayout layout =
          DockingLayout(root: DockingRow([dockingItem('a'), dockingItem('b')]));
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.row);
      expect(layout.root!.id, 1);
      DockingRow row = layout.root! as DockingRow;
      expect(row.childrenCount, 2);
      DockingArea area = row.childAt(0);
      expect(area.id, 2);
      expect(area.type, DockingAreaType.item);
      area = row.childAt(1);
      expect(area.id, 3);
      expect(area.type, DockingAreaType.item);
    });

    test('column', () {
      DockingLayout layout = DockingLayout(
          root: DockingColumn([dockingItem('a'), dockingItem('b')]));
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.column);
      expect(layout.root!.id, 1);
      DockingColumn column = layout.root! as DockingColumn;
      expect(column.childrenCount, 2);
      testDockingItem(column.childAt(0), id:2,name: 'a', hasParent:true);
      testDockingItem(column.childAt(1), id:3, name:'b',hasParent: true);
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
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout =
          DockingLayout(root: DockingRow([dockingItem('a'), itemB, itemC]));
      layout.remove(itemC);
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.row);
      DockingRow row = layout.root as DockingRow;
      expect(row.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!,id: 2, name:'a',hasParent: false);
    });

    test('column item', () {
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout =
          DockingLayout(root: DockingColumn([dockingItem('a'), itemB, itemC]));
      layout.remove(itemC);
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.column);
      DockingColumn column = layout.root as DockingColumn;
      expect(column.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!,id: 2,name: 'a',hasParent: false);
    });

    test('tabs item', () {
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout =
          DockingLayout(root: DockingTabs([dockingItem('a'), itemB, itemC]));
      layout.remove(itemC);
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.tabs);
      DockingTabs tabs = layout.root as DockingTabs;
      expect(tabs.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!, id:2,name: 'a',hasParent: false);
    });

    test('column row item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingLayout layout = DockingLayout(
          root: DockingColumn([
        DockingRow([itemA, itemB]),
        itemC
      ]));
      layout.remove(itemC);
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.row);
      DockingRow row = layout.root as DockingRow;
      expect(row.childrenCount, 2);
      layout.remove(itemB);
      testDockingItem(layout.root!,id: 3, name:'a',hasParent: false);
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
      layout.remove(itemD);
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.row);
      DockingRow row = layout.root as DockingRow;
      expect(row.childrenCount, 3);
      testDockingItem(row.childAt(0),id: 2,name: 'a',hasParent: true);
      testDockingItem(row.childAt(1), id:5, name:'b', hasParent:true);
      testDockingItem(row.childAt(2),id: 6,name: 'c',hasParent: true);
      layout.remove(itemB);
      expect(row.childrenCount, 2);
      testDockingItem(row.childAt(0), id:2,name: 'a',hasParent: true);
      testDockingItem(row.childAt(1),id: 6,name: 'c', hasParent:true);
      layout.remove(itemC);
      testDockingItem(layout.root!,id: 2, name:'a',hasParent: false);
    });
  });
}
