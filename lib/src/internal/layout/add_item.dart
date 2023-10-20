import 'package:docking/src/internal/layout/drop_item.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:meta/meta.dart';

/// Adds [DockingItem] to the layout.
@internal
class AddItem extends DropItem {
  AddItem(
      {required DockingItem newItem,
      required DropArea targetArea,
      DropPosition? dropPosition,
      int? dropIndex})
      : super(
            dropItem: newItem,
            targetArea: targetArea,
            dropPosition: dropPosition,
            dropIndex: dropIndex);

  @override
  void validateDropItem(DockingLayout layout, DockingArea area) {
    super.validateDropItem(layout, area);
    if (area.layoutId != -1) {
      throw ArgumentError('DockingArea already belongs to some layout.');
    }
  }

  @override
  void validateTargetArea(DockingLayout layout, DockingArea area) {
    super.validateTargetArea(layout, area);
    if (area.layoutId != layout.id) {
      throw ArgumentError(
          'DockingArea belongs to another layout. Keep the layout in the state of your StatefulWidget.');
    }
  }
}
