import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(dynamic id) {
  return DockingItem(id: id, widget: Container());
}

void main() {
  group('find', () {
    test('empty layout', () {
      DockingLayout layout = DockingLayout(root: null);
      expect(layout.findDockingItem(1), isNull);
    });
    test('row', () {
      DockingItem item1 = dockingItem(1);
      DockingItem item2 = dockingItem(2);
      DockingRow row = DockingRow([item1, item2], id: 'row');
      DockingLayout layout = DockingLayout(root: row);
      expect(layout.findDockingItem(1), item1);
      expect(layout.findDockingItem(2), item2);
      expect(layout.findDockingItem(3), isNull);
      expect(layout.findDockingArea('row'), row);
    });
    test('column', () {
      DockingItem item1 = dockingItem(1);
      DockingItem item2 = dockingItem(2);
      DockingColumn column = DockingColumn([item1, item2], id: 'column');
      DockingLayout layout = DockingLayout(root: column);
      expect(layout.findDockingItem(1), item1);
      expect(layout.findDockingItem(2), item2);
      expect(layout.findDockingItem(3), isNull);
      expect(layout.findDockingArea('column'), column);
    });

    test('tabs', () {
      DockingItem item1 = dockingItem(1);
      DockingItem item2 = dockingItem(2);
      DockingTabs tabs = DockingTabs([item1, item2], id: 'tabs');
      DockingLayout layout = DockingLayout(root: tabs);
      expect(layout.findDockingItem(1), item1);
      expect(layout.findDockingItem(2), item2);
      expect(layout.findDockingItem(3), isNull);
      expect(layout.findDockingArea('tabs'), tabs);
    });

    test('tabs with item', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      DockingColumn column = DockingColumn([row, tabs], id: 'column');
      DockingLayout layout = DockingLayout(root: column);
      expect(layout.findDockingTabsWithItem('a'), null);
      expect(layout.findDockingTabsWithItem('e'), tabs);
    });

    test('complex', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      DockingColumn column = DockingColumn([row, tabs], id: 'column');
      DockingLayout layout = DockingLayout(root: column);

      expect(layout.findDockingItem('a'), itemA);
      expect(layout.findDockingItem('b'), itemB);
      expect(layout.findDockingItem('c'), itemC);
      expect(layout.findDockingItem('d'), itemD);
      expect(layout.findDockingItem('e'), itemE);
      expect(layout.findDockingItem('f'), isNull);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
      expect(layout.findDockingArea('row'), row);
      expect(layout.findDockingArea('column'), column);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
    });

    test('complex 2', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingItem itemF = dockingItem('f');
      DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      DockingColumn column = DockingColumn([row, tabs, itemF], id: 'column');
      DockingLayout layout = DockingLayout(root: column);

      expect(layout.findDockingItem('a'), itemA);
      expect(layout.findDockingItem('b'), itemB);
      expect(layout.findDockingItem('c'), itemC);
      expect(layout.findDockingItem('d'), itemD);
      expect(layout.findDockingItem('e'), itemE);
      expect(layout.findDockingItem('f'), itemF);
      expect(layout.findDockingItem('g'), isNull);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
      expect(layout.findDockingArea('row'), row);
      expect(layout.findDockingArea('column'), column);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
    });

    test('complex 3', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingItem itemF = dockingItem('f');
      DockingItem itemG = dockingItem('g');
      DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      DockingColumn column = DockingColumn([row, tabs, itemF], id: 'column');
      DockingRow row2 = DockingRow([itemG, column], id: 'row2');
      DockingLayout layout = DockingLayout(root: row2);

      expect(layout.findDockingItem('a'), itemA);
      expect(layout.findDockingItem('b'), itemB);
      expect(layout.findDockingItem('c'), itemC);
      expect(layout.findDockingItem('d'), itemD);
      expect(layout.findDockingItem('e'), itemE);
      expect(layout.findDockingItem('f'), itemF);
      expect(layout.findDockingItem('g'), itemG);
      expect(layout.findDockingItem('h'), isNull);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
      expect(layout.findDockingArea('row'), row);
      expect(layout.findDockingArea('row2'), row2);
      expect(layout.findDockingArea('column'), column);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
    });
  });
}
