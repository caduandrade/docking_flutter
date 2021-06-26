import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_util.dart';

void main() {
  group('constructor', () {
    test('DockingItem', () {
      testDockingItem(dockingItem(null),
          id: -1, hasParent: false, level: 0, path: 'I');
      testDockingItem(dockingItem('a'),
          id: -1, name: 'a', hasParent: false, level: 0, path: 'I');
    });
  });

  test('empty layout', () {
    DockingLayout layout = DockingLayout();
    expect(layout.root, isNull);
  });

  group('not allowed', () {
    test('build row in row', () {
      expect(
          () => DockingRow([
                DockingRow([dockingItem('a'), dockingItem('a')]),
                dockingItem('a')
              ]),
          throwsArgumentError);
    });

    test('build column in column', () {
      expect(
          () => DockingColumn([
                DockingColumn([dockingItem('a'), dockingItem('a')]),
                dockingItem('a')
              ]),
          throwsArgumentError);
    });

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
