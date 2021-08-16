import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  test('DockingItem', () {
    testDockingItem(dockingItem(null),
        layoutIndex: -1, hasParent: false, level: 0, path: 'I');
    testDockingItem(dockingItem('a'),
        layoutIndex: -1, name: 'a', hasParent: false, level: 0, path: 'I');
  });

  test('empty layout', () {
    DockingLayout layout = DockingLayout();
    expect(layout.root, isNull);
  });

  group('not allowed', () {
    test('column children count', () {
      expect(() => DockingColumn([dockingItem('a')]), throwsArgumentError);
      expect(() => DockingColumn([]), throwsArgumentError);
    });

    test('row children count', () {
      expect(() => DockingRow([dockingItem('a')]), throwsArgumentError);
      expect(() => DockingRow([]), throwsArgumentError);
    });

    test('tabs children count', () {
      expect(() => DockingTabs([dockingItem('a')]), throwsArgumentError);
      expect(() => DockingTabs([]), throwsArgumentError);
    });
  });
}
