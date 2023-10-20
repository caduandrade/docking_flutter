import 'package:docking/docking.dart';
import 'package:docking/src/internal/layout/layout_stringify.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

void main() {
  final LayoutParser defaultParser = DefaultLayoutParser();

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

      expect(() => LayoutStringify.stringifyParent(parent: column),
          childNotBelongAnyLayoutException());
      expect(() => LayoutStringify.stringifyParent(parent: row),
          childNotBelongAnyLayoutException());
      expect(() => LayoutStringify.stringifyParent(parent: tabs),
          childNotBelongAnyLayoutException());

      DockingLayout(root: column);

      expect(LayoutStringify.stringifyParent(parent: column), '2,3,6');
      expect(LayoutStringify.stringifyParent(parent: row), '4,5');
      expect(LayoutStringify.stringifyParent(parent: tabs), '7,8');
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

      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: column),
          '0;;');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: row),
          '0;;0.4');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: tabs),
          '0;;');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: itemA),
          '0;;');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: itemB),
          '0;;0.2');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: itemC),
          '3;idC;');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: itemD),
          '3;1.2;');
      expect(LayoutStringify.stringifyArea(parser: defaultParser, area: itemE),
          '0;;0.3');
    });
    test('stringifyTabs', () {
      DockingItem itemA = dockingItem('a');
      DockingItem itemB = dockingItem('b');
      DockingTabs tabs = DockingTabs([itemA, itemB], maximized: true);

      DockingLayout(root: tabs);

      expect(LayoutStringify.stringifyTabs(tabs: tabs), 'T');
    });
    test('stringifyItem', () {
      DockingItem itemA = DockingItem(widget: Container());
      DockingItem itemB = DockingItem(maximized: true, widget: Container());
      DockingRow row = DockingRow([itemA, itemB]);

      DockingLayout(root: row);

      expect(LayoutStringify.stringifyItem(item: itemA), 'F');
      expect(LayoutStringify.stringifyItem(item: itemB), 'T');
    });
    test('stringifyArea - CustomIdParser', () {
      DockingItem itemA = DockingItem(id: 1.2, widget: Container());
      DockingItem itemB = DockingItem(id: 3.3, widget: Container());
      DockingRow row = DockingRow([itemA, itemB], id: 5.5);

      DockingLayout(root: row);

      LayoutParser parser = CustomIdParser();

      expect(
          LayoutStringify.stringifyArea(parser: parser, area: itemA), '3;2.2;');
      expect(
          LayoutStringify.stringifyArea(parser: parser, area: itemB), '3;4.3;');
      expect(
          LayoutStringify.stringifyArea(parser: parser, area: row), '3;6.5;');
    });
    test('stringifyArea - CustomIdClassParser', () {
      DockingItem itemA =
          DockingItem(id: CustomClass('itemA'), widget: Container());
      DockingItem itemB =
          DockingItem(id: CustomClass('itemB'), widget: Container());
      DockingRow row = DockingRow([itemA, itemB], id: CustomClass('row'));

      DockingLayout(root: row);

      LayoutParser parser = CustomIdClassParser();

      expect(LayoutStringify.stringifyArea(parser: parser, area: itemA),
          '5;itemA;');
      expect(LayoutStringify.stringifyArea(parser: parser, area: itemB),
          '5;itemB;');
      expect(
          LayoutStringify.stringifyArea(parser: parser, area: row), '3;row;');
    });
    test('stringify - simple', () {
      DockingItem itemA =
          DockingItem(id: 'idA', value: 'valueA', widget: Container());
      DockingItem itemB =
          DockingItem(id: 'idB', value: 'valueB', widget: Container());

      DockingRow row = DockingRow([itemA, itemB], weight: 1);

      DockingLayout layout = DockingLayout(root: row);

      expect(layout.stringify(parser: defaultParser),
          'V1:3:1(R;0;;1.0;2,3),2(I;3;idA;;F),3(I;3;idB;;F)');
    });
  });
}

class CustomClass {
  CustomClass(this.value);

  final String value;
}

class DefaultLayoutParser extends LayoutParser with LayoutParserMixin {}

class DefaultAreaBuilder extends AreaBuilder with AreaBuilderMixin {
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
