import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DockingItem', () {
    test('new instance', () {
      DockingItem item = DockingItem(widget: Container());
      expect(item.id, 0);
      expect(item.name, isNull);
      expect(item.parent, isNull);
      expect(item.type, DockingAreaType.item);

      item = DockingItem(name: 'a', widget: Container());
      expect(item.id, 0);
      expect(item.name, isNotNull);
      expect(item.name, 'a');
      expect(item.parent, isNull);
    });
  });
}
