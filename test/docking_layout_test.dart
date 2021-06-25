import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(String? name) {
  return DockingItem(name: name, widget: Container());
}

void main() {
  test('empty', () {
    DockingLayout layout = DockingLayout();
    expect(layout.root, isNull);
  });

  group('default id and parent', () {
    test('item', () {
      DockingLayout layout = DockingLayout(root: dockingItem('a'));
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.item);
      expect(layout.root!.id, 1);
      expect(layout.root!.parent, isNotNull);
    });

    test('row', () {
      DockingLayout layout =
          DockingLayout(root: DockingRow([dockingItem('a'), dockingItem('b')]));
      expect(layout.root, isNotNull);
      expect(layout.root!.type, DockingAreaType.row);
      expect(layout.root!.id, 1);
    });
  });
}
