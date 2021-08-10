import 'package:docking/src/layout/docking_layout.dart';

abstract class LayoutModifier {
  DockingArea? newLayout(DockingLayout layout);

  void validate(int layoutId, DockingArea area) {
    if (area.disposed) {
      throw ArgumentError('DockingArea already has been disposed.');
    }
    if (area.index == -1) {
      throw ArgumentError('DockingArea does not belong to this layout.');
    }
    if (area.layoutId != layoutId) {
      throw ArgumentError(
          'DockingArea belongs to other layout. Keep the layout in the state of your StatefulWidget.');
    }
  }
}
