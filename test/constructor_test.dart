import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_util.dart';

void main() {
  group('constructor', () {
    test('DockingItem', () {
      testDockingItem(dockingItem(null), -1, null, false);
      testDockingItem(dockingItem('a'), -1, 'a', false);
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
