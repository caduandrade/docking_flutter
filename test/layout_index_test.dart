import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('Layout indexes', () {
    test('Indexes', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingRow row = DockingRow([itemB, itemC]);
      DockingTabs tabs = DockingTabs([itemD, itemE]);
      DockingColumn column = DockingColumn([itemA, row, tabs]);
      DockingLayout layout = DockingLayout(root: column);
      expect(column.index, 1);
      expect(itemA.index, 2);
      expect(row.index, 3);
      expect(itemB.index, 4);
      expect(itemC.index, 5);
      expect(tabs.index, 6);
      expect(itemD.index, 7);
      expect(itemE.index, 8);
      expect(layout.hierarchy(indexInfo: true), 'C1(I2,R3(I4,I5),T6(I7,I8))');
    });
  });
}
