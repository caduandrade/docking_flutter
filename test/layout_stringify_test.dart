import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

void main() {
  final LayoutParser parser = LayoutParser();

  group('LayoutParser - stringify', () {
    test('stringifyParent', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingRow row = DockingRow([itemB, itemC]);
      DockingTabs tabs = DockingTabs([itemD, itemE]);
      DockingColumn column = DockingColumn([itemA, row, tabs]);

      expect(() => parser.stringifyParent(parent: column),
          childNotBelongAnyLayoutException());
      expect(() => parser.stringifyParent(parent: row),
          childNotBelongAnyLayoutException());
      expect(() => parser.stringifyParent(parent: tabs),
          childNotBelongAnyLayoutException());

      DockingLayout(root: column);

      expect(parser.stringifyParent(parent: column), '2,3,6');
      expect(parser.stringifyParent(parent: row), '4,5');
      expect(parser.stringifyParent(parent: tabs), '7,8');
    });
  });
}
