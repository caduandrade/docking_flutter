import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

void main() {
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

      final LayoutParser parser = DefaultLayoutParser();

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
      DockingItem itemC = DockingItem(id: 'idC', widget: Container());
      DockingItem itemD = DockingItem(id: 1.2, widget: Container());
      DockingItem itemE = DockingItem(widget: Container(), weight: .3);
      DockingRow row = DockingRow([itemB, itemC], weight: .4);
      DockingTabs tabs = DockingTabs([itemD, itemE]);
      DockingColumn column = DockingColumn([itemA, row, tabs]);

      DockingLayout(root: column);

      final LayoutParser parser = DefaultLayoutParser();

      expect(parser.stringifyArea(area: column), '0;;');
      expect(parser.stringifyArea(area: row), '0;;0.4');
      expect(parser.stringifyArea(area: tabs), '0;;');
      expect(parser.stringifyArea(area: itemA), '0;;');
      expect(parser.stringifyArea(area: itemB), '0;;0.2');
      expect(parser.stringifyArea(area: itemC), '3;idC;');
      expect(parser.stringifyArea(area: itemD), '3;1.2;');
      expect(parser.stringifyArea(area: itemE), '0;;0.3');
    });
    test('stringifyTabs', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingTabs tabs = DockingTabs([itemA, itemB], maximized: true);

      DockingLayout(root: tabs);

      final LayoutParser parser = DefaultLayoutParser();

      expect(parser.stringifyTabs(tabs: tabs), 'T');
    });
    test('stringifyItem', () {
      DockingItem itemA = DockingItem(widget: Container());
      DockingItem itemB = DockingItem(maximized: true, widget: Container());
      DockingRow row = DockingRow([itemA, itemB]);

      DockingLayout(root: row);

      final LayoutParser parser = DefaultLayoutParser();

      expect(parser.stringifyItem(item: itemA), 'F');
      expect(parser.stringifyItem(item: itemB), 'T');
    });
    test('stringifyArea - CustomIdParser', () {
      DockingItem itemA = DockingItem(id: 1.2, widget: Container());
      DockingItem itemB = DockingItem(id: 3.3, widget: Container());
      DockingRow row = DockingRow([itemA, itemB], id: 5.5);

      DockingLayout(root: row);

      LayoutParser parser = CustomIdParser();

      expect(parser.stringifyArea(area: itemA), '3;2.2;');
      expect(parser.stringifyArea(area: itemB), '3;4.3;');
      expect(parser.stringifyArea(area: row), '3;6.5;');
    });
    test('stringifyArea - CustomIdClassParser', () {
      DockingItem itemA =
          DockingItem(id: CustomClass('itemA'), widget: Container());
      DockingItem itemB =
          DockingItem(id: CustomClass('itemB'), widget: Container());
      DockingRow row = DockingRow([itemA, itemB], id: CustomClass('row'));

      DockingLayout(root: row);

      LayoutParser parser = CustomIdClassParser();

      expect(parser.stringifyArea(area: itemA), '5;itemA;');
      expect(parser.stringifyArea(area: itemB), '5;itemB;');
      expect(parser.stringifyArea(area: row), '3;row;');
    });
    test('stringify - simple', () {
      DockingItem itemA =
          DockingItem(id: 'idA', value: 'valueA', widget: Container());
      DockingItem itemB =
          DockingItem(id: 'idB', value: 'valueB', widget: Container());

      DockingRow row = DockingRow([itemA, itemB], weight: 1);

      DockingLayout layout = DockingLayout(root: row);

      LayoutParser parser = DefaultLayoutParser();

      expect(parser.stringify(layout: layout),
          'V1:3:1(R;0;;1.0;2,3),2(I;3;idA;;F),3(I;3;idB;;F)');
    });
  });
}

class CustomClass {
  CustomClass(this.value);

  final String value;
}

class DefaultLayoutParser extends LayoutParser
    with LayoutParserIdMixin, LayoutParserBuildsMixin {
  @override
  DockingItem buildDockingItem(
      {required id, required double? weight, required bool maximized}) {
    throw UnimplementedError();
  }
}

class CustomIdParser extends DefaultLayoutParser {
  @override
  String idToString(dynamic id) {
    return (id + 1).toString();
  }

  @override
  dynamic stringToId(String id) {
    double v = double.parse(id);
    return v - 1;
  }
}

class CustomIdClassParser extends DefaultLayoutParser {
  @override
  String idToString(dynamic id) {
    CustomClass customClass = id;
    return customClass.value;
  }

  @override
  dynamic stringToId(String id) {
    return CustomClass(id);
  }
}
