import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_item.dart';

/// Rearranges the layout given a new location for a [DockingItem].
class MoveItem extends DropItem {
  MoveItem(
      {required DockingItem draggedItem,
      required DropArea targetArea,
      required DropPosition dropPosition})
      : super(
            dropItem: draggedItem,
            targetArea: targetArea,
            dropPosition: dropPosition);

  @override
  void validate(DockingLayout layout, DockingArea area) {
    super.validate(layout, area);
    if (area.layoutId != layout.id) {
      throw ArgumentError(
          'DockingArea belongs to another layout. Keep the layout in the state of your StatefulWidget.');
    }
  }
}
