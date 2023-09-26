import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
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
    test('stringifyArea', () {
      DockingItem itemA = DockingItem(widget: Container());
      DockingItem itemB = DockingItem(widget: Container(), weight: .2);
      DockingItem itemC = DockingItem(widget: Container(), minimalSize: 100);
      DockingItem itemD = DockingItem(widget: Container(), minimalWeight: .2);
      DockingItem itemE =
          DockingItem(widget: Container(), weight: .3, minimalWeight: .2);
      DockingRow row = DockingRow([itemB, itemC], weight: .4);
      DockingTabs tabs = DockingTabs([itemD, itemE], minimalSize: 200);
      DockingColumn column =
          DockingColumn([itemA, row, tabs], minimalWeight: .5);

      DockingLayout(root: column);

      expect(parser.stringifyArea(area: column), ';0.5;');
      expect(parser.stringifyArea(area: row), '0.4;;');
      expect(parser.stringifyArea(area: tabs), ';;200');
      expect(parser.stringifyArea(area: itemA), ';;');
      expect(parser.stringifyArea(area: itemB), '0.2;;');
      expect(parser.stringifyArea(area: itemC), ';;100');
      expect(parser.stringifyArea(area: itemD), ';0.2;');
      expect(parser.stringifyArea(area: itemE), '0.3;0.2;');
    });
  });
}
