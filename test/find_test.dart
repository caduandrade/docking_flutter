import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(dynamic id) {
  return DockingItem(id: id, widget: Container());
}

void main() {
  group('find item', () {
    test('empty layout', () {
      DockingLayout layout = DockingLayout(root: null);
      expect(layout.findDockingItem(1), isNull);
    });
    test('row', () {
      DockingItem item1 = dockingItem(1);
      DockingItem item2 = dockingItem(2);
      DockingRow row = DockingRow([item1, item2]);
      DockingLayout layout = DockingLayout(root: row);
      expect(layout.findDockingItem(1), isNotNull);
      expect(layout.findDockingItem(2), isNotNull);
      expect(layout.findDockingItem(3), isNull);
    });
    test('column', () {
      DockingItem item1 = dockingItem(1);
      DockingItem item2 = dockingItem(2);
      DockingColumn column = DockingColumn([item1, item2]);
      DockingLayout layout = DockingLayout(root: column);
      expect(layout.findDockingItem(1), isNotNull);
      expect(layout.findDockingItem(2), isNotNull);
      expect(layout.findDockingItem(3), isNull);
    });

    test('tabs', () {
      DockingItem itemB = dockingItem(1);
      DockingItem itemC = dockingItem(2);
      DockingTabs tabs = DockingTabs([itemB, itemC]);
      DockingLayout layout = DockingLayout(root: tabs);
      expect(layout.findDockingItem(1), isNotNull);
      expect(layout.findDockingItem(2), isNotNull);
      expect(layout.findDockingItem(3), isNull);
    });

    test('complex', () {
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

      expect(layout.findDockingItem('a'), isNotNull);
      expect(layout.findDockingItem('b'), isNotNull);
      expect(layout.findDockingItem('c'), isNotNull);
      expect(layout.findDockingItem('d'), isNotNull);
      expect(layout.findDockingItem('e'), isNotNull);
      expect(layout.findDockingItem('f'), isNull);
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

      expect(layout.findDockingItem('a'), isNotNull);
      expect(layout.findDockingItem('b'), isNotNull);
      expect(layout.findDockingItem('c'), isNotNull);
      expect(layout.findDockingItem('d'), isNotNull);
      expect(layout.findDockingItem('e'), isNotNull);
      expect(layout.findDockingItem('f'), isNotNull);
      expect(layout.findDockingItem('g'), isNull);
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

      expect(layout.findDockingItem('a'), isNotNull);
      expect(layout.findDockingItem('b'), isNotNull);
      expect(layout.findDockingItem('c'), isNotNull);
      expect(layout.findDockingItem('d'), isNotNull);
      expect(layout.findDockingItem('e'), isNotNull);
      expect(layout.findDockingItem('f'), isNotNull);
      expect(layout.findDockingItem('g'), isNotNull);
      expect(layout.findDockingItem('h'), isNull);
    });
  });
}
