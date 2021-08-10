import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_modifier.dart';

/// Rearranges the layout given a new location for a [DockingItem].
class MoveItem extends LayoutModifier {
  MoveItem(
      {required this.draggedItem,
      required this.targetArea,
      required this.dropPosition});

  final DockingItem draggedItem;
  final DropArea targetArea;
  final DropPosition dropPosition;

  @override
  DockingArea? newLayout(DockingLayout layout) {
    if (draggedItem == targetArea) {
      throw ArgumentError(
          'Argument draggedItem cannot be the same as argument targetArea. A DockingItem cannot be rearranged on itself.');
    }
    validate(layout.id, draggedItem);
    if (!(targetArea is DockingArea)) {
      throw ArgumentError('Argument targetArea is not a DockingArea.');
    }
    validate(layout.id, targetArea as DockingArea);
    if (layout.root != null) {
      return _buildLayout(layout.root!);
    }
    return null;
  }

  DockingArea? _buildLayout(DockingArea area) {
    if (area is DockingItem) {
      DockingItem dockingItem = area;
      if (dockingItem == draggedItem && dockingItem == targetArea) {
        throw StateError('DockingItem is dragged and target at same time.');
      } else if (dockingItem == draggedItem) {
        // ignore
        return null;
      } else if (dockingItem == targetArea) {
        DockingItem newDraggedItem = DockingItem.clone(draggedItem);
        if (dropPosition == DropPosition.center) {
          return DockingTabs([DockingItem.clone(dockingItem), newDraggedItem]);
        } else if (dropPosition == DropPosition.top) {
          return DockingColumn(
              [newDraggedItem, DockingItem.clone(dockingItem)]);
        } else if (dropPosition == DropPosition.bottom) {
          return DockingColumn(
              [DockingItem.clone(dockingItem), newDraggedItem]);
        } else if (dropPosition == DropPosition.left) {
          return DockingRow([newDraggedItem, DockingItem.clone(dockingItem)]);
        } else if (dropPosition == DropPosition.right) {
          return DockingRow([DockingItem.clone(dockingItem), newDraggedItem]);
        } else {
          throw ArgumentError(
              'DropPosition not recognized: ' + dropPosition.toString());
        }
      }
      return DockingItem.clone(area);
    } else if (area is DockingTabs) {
      DockingTabs dockingTabs = area;
      List<DockingItem> children = [];
      dockingTabs.forEach((child) {
        if (child != draggedItem) {
          children.add(DockingItem.clone(child));
        }
      });
      DockingArea? newArea;
      if (children.length == 1) {
        newArea = children.first;
      } else {
        newArea = DockingTabs(children);
      }
      if (dockingTabs == targetArea) {
        DockingItem newDraggedItem = DockingItem.clone(draggedItem);
        if (dropPosition == DropPosition.center) {
          children.add(newDraggedItem);
          return DockingTabs(children);
        } else if (dropPosition == DropPosition.top) {
          return DockingColumn([newDraggedItem, newArea]);
        } else if (dropPosition == DropPosition.bottom) {
          return DockingColumn([newArea, newDraggedItem]);
        } else if (dropPosition == DropPosition.left) {
          return DockingRow([newDraggedItem, newArea]);
        } else if (dropPosition == DropPosition.right) {
          return DockingRow([newArea, newDraggedItem]);
        } else {
          throw ArgumentError(
              'DropPosition not recognized: ' + dropPosition.toString());
        }
      }
      return newArea;
    } else if (area is DockingParentArea) {
      List<DockingArea> children = [];
      area.forEach((child) {
        DockingArea? newChild = _buildLayout(child);
        if (newChild != null) {
          children.add(newChild);
        }
      });
      if (children.length == 0) {
        return null;
      } else if (children.length == 1) {
        return children.first;
      }
      if (area is DockingRow) {
        return DockingRow(children);
      } else if (area is DockingColumn) {
        return DockingColumn(children);
      }
      throw StateError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw StateError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }
}
