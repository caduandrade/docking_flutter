import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('default id and parent', () {
    test('item', () {
      DockingLayout layout = DockingLayout(root: dockingItem('a'));
      expect(layout.root, isNotNull);
      testDockingItem(layout.root!,
          layoutIndex: 1, name: 'a', hasParent: false, path: 'I');
    });

    test('row', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingRow row = DockingRow([itemA, itemB]);
      DockingLayout layout = DockingLayout(root: row);
      expect(layout.root, row);
      testDockingParentArea(row,
          childrenCount: 2, hasParent: false, path: 'R', level: 0);
      testDockingItem(row.childAt(0),
          layoutIndex: 2, name: 'a', hasParent: true, path: 'RI', level: 1);
      expect(row.childAt(0), itemA);
      testDockingItem(row.childAt(1),
          layoutIndex: 3, name: 'b', hasParent: true, path: 'RI', level: 1);
      expect(row.childAt(1), itemB);
    });

    test('column', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingLayout layout = DockingLayout(root: DockingColumn([itemA, itemB]));
      DockingColumn column = rootAsColumn(layout);
      expect(column.childrenCount, 2);
      testDockingItem(column.childAt(0),
          layoutIndex: 2, name: 'a', hasParent: true);
      expect(column.childAt(0), itemA);
      testDockingItem(column.childAt(1),
          layoutIndex: 3, name: 'b', hasParent: true);
      expect(column.childAt(1), itemB);
    });
  });
}
