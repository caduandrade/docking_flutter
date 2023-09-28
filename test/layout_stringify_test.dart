import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

class CustomClass {
  CustomClass(this.value);

  final String value;
}

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
    test('stringifyTabs', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingItem itemC = dockingItem('c');
      DockingItem itemD = dockingItem('d');
      DockingItem itemE = dockingItem('e');
      DockingRow row = DockingRow([itemB, itemC]);
      DockingTabs tabs = DockingTabs([itemD, itemE], maximizable: false);
      DockingColumn column = DockingColumn([itemA, row, tabs]);

      DockingLayout(root: column);

      expect(parser.stringifyTabs(tabs: tabs), 'F;F');
    });
    test('stringifyItem', () {
      DockingItem itemA = DockingItem(name: 'a', widget: Container());
      DockingItem itemB =
          DockingItem(id: 'id-b', name: 'b', widget: Container());
      DockingItem itemC =
          DockingItem(name: 'c', value: 'value-c', widget: Container());
      DockingItem itemD = DockingItem(
          id: 'id-d', name: 'd', value: 'value-d', widget: Container());
      DockingItem itemE = DockingItem(
          name: 'e',
          closable: false,
          maximizable: true,
          maximized: true,
          widget: Container());
      DockingItem itemF = DockingItem(
          id: 'id;', name: 'f;', value: 'value;', widget: Container());
      DockingRow row = DockingRow([itemA, itemB, itemC, itemD, itemE, itemF]);

      DockingLayout(root: row);

      expect(
          parser.stringifyItem(
              item: itemA,
              idToString: LayoutParser.defaultIdToString,
              valueToString: LayoutParser.defaultValueToString),
          '0;;1;a;0;;T;;F');
      expect(
          parser.stringifyItem(
              item: itemB,
              idToString: LayoutParser.defaultIdToString,
              valueToString: LayoutParser.defaultValueToString),
          '4;id-b;1;b;0;;T;;F');
      expect(
          parser.stringifyItem(
              item: itemC,
              idToString: LayoutParser.defaultIdToString,
              valueToString: LayoutParser.defaultValueToString),
          '0;;1;c;7;value-c;T;;F');
      expect(
          parser.stringifyItem(
              item: itemD,
              idToString: LayoutParser.defaultIdToString,
              valueToString: LayoutParser.defaultValueToString),
          '4;id-d;1;d;7;value-d;T;;F');
      expect(
          parser.stringifyItem(
              item: itemE,
              idToString: LayoutParser.defaultIdToString,
              valueToString: LayoutParser.defaultValueToString),
          '0;;1;e;0;;F;T;T');
      expect(
          parser.stringifyItem(
              item: itemF,
              idToString: LayoutParser.defaultIdToString,
              valueToString: LayoutParser.defaultValueToString),
          '3;id;;2;f;;6;value;;T;;F');
    });
    test('stringifyItem - idToString', () {
      DockingItem itemA = DockingItem(id: 1.2, widget: Container());
      DockingItem itemB = DockingItem(id: null, widget: Container());
      DockingItem itemC = DockingItem(widget: Container());
      DockingItem itemD =
          DockingItem(id: CustomClass('id-class'), widget: Container());

      DockingRow row = DockingRow([itemA, itemB, itemC, itemD]);

      DockingLayout(root: row);

      expect(
          parser.stringifyItem(
              item: itemA,
              idToString: (id) => (id + 1).toString(),
              valueToString: LayoutParser.defaultValueToString),
          '3;2.2;0;;0;;T;;F');
      expect(
          parser.stringifyItem(
              item: itemB,
              idToString: (id) {
                if (id == null) {
                  return 'X';
                }
                return id.toString();
              },
              valueToString: LayoutParser.defaultValueToString),
          '1;X;0;;0;;T;;F');
      expect(
          parser.stringifyItem(
              item: itemC,
              idToString: (id) {
                if (id == null) {
                  return 'Y';
                }
                return id.toString();
              },
              valueToString: LayoutParser.defaultValueToString),
          '1;Y;0;;0;;T;;F');
      expect(
          parser.stringifyItem(
              item: itemD,
              idToString: (id) {
                if (id is CustomClass) {
                  return id.value;
                }
                return '';
              },
              valueToString: LayoutParser.defaultValueToString),
          '8;id-class;0;;0;;T;;F');
    });
    test('stringifyItem - valueToString', () {
      DockingItem itemA =
          DockingItem(value: CustomClass('value'), widget: Container());
      DockingItem itemB = DockingItem(value: 1.5, widget: Container());

      DockingRow row = DockingRow([itemA, itemB]);

      DockingLayout(root: row);

      expect(
          parser.stringifyItem(
              item: itemA,
              idToString: LayoutParser.defaultIdToString,
              valueToString: (value) {
                if (value is CustomClass) {
                  return value.value;
                }
                return '';
              }),
          '0;;0;;5;value;T;;F');
      expect(
          parser.stringifyItem(
              item: itemB,
              idToString: LayoutParser.defaultIdToString,
              valueToString: (value) {
                if (value is double) {
                  return (value + 2).toString();
                }
                return '';
              }),
          '0;;0;;3;3.5;T;;F');
    });
    test('stringify - simple', () {
      DockingItem itemA =
          DockingItem(id: 'idA', value: 'valueA', widget: Container());
      DockingItem itemB = DockingItem(
          id: 'idB', value: 'valueB', minimalWeight: .5, widget: Container());

      DockingRow row = DockingRow([itemA, itemB], weight: 1, minimalSize: 50);

      DockingLayout layout = DockingLayout(root: row);

      expect(parser.stringify(layout: layout),
          'V1:3:1(R;1.0;;50;2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)');
    });
  });
}
