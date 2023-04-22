import 'package:docking/src/layout/docking_layout.dart';
import 'package:meta/meta.dart';

/// Represents a layout modifier.
@internal
abstract class LayoutModifier {
  /// Builds a new root given a layout.
  DockingArea? newLayout(DockingLayout layout);

  /// Validates a [DockingArea] parameter for this modifier.
  void validate(DockingLayout layout, DockingArea area) {
    if (area.disposed) {
      throw ArgumentError('DockingArea already has been disposed.');
    }
  }
}
