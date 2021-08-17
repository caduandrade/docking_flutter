import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_modifier.dart';

/// Drops a [DockingItem] in the layout.
class DropItem extends LayoutModifier {
  DropItem(
      {required this.dropItem,
      required this.targetArea,
      required this.dropPosition});

  final DockingItem dropItem;
  final DropArea targetArea;
  final DropPosition dropPosition;

  @override
  DockingArea? newLayout(DockingLayout layout) {
    if (dropItem == targetArea) {
      throw ArgumentError(
          'Argument draggedItem cannot be the same as argument targetArea. A DockingItem cannot be rearranged on itself.');
    }
    validateDropItem(layout, dropItem);
    if (!(targetArea is DockingArea)) {
      throw ArgumentError('Argument targetArea is not a DockingArea.');
    }
    validateTargetArea(layout, targetArea as DockingArea);
    if (layout.root != null) {
      return _buildLayout(layout.root!);
    }
    return null;
  }

  /// Validates a drop item parameter for this modifier.
  void validateDropItem(DockingLayout layout, DockingArea area) {
    validate(layout, area);
  }

  /// Validates a target area parameter for this modifier.
  void validateTargetArea(DockingLayout layout, DockingArea area) {
    validate(layout, area);
  }

  /// Builds a new root.
  DockingArea? _buildLayout(DockingArea area) {
    if (area is DockingItem) {
      DockingItem dockingItem = area;
      if (dockingItem == dropItem && dockingItem == targetArea) {
        throw StateError('DockingItem is dragged and target at same time.');
      } else if (dockingItem == dropItem) {
        // ignore
        return null;
      } else if (dockingItem == targetArea) {
        DockingItem newDraggedItem = DockingItem.clone(dropItem);
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
        if (child == targetArea) {
          throw ArgumentError('Nested tabbed panels are not allowed.');
        }
        if (child != dropItem) {
          children.add(DockingItem.clone(child));
        }
      });
      DockingArea? newArea;
      if (children.length == 1) {
        newArea = children.first;
      } else {
        newArea = DockingTabs(children);
        (newArea as DockingTabs).selectedIndex = dockingTabs.selectedIndex;
      }
      if (dockingTabs == targetArea) {
        DockingItem newDraggedItem = DockingItem.clone(dropItem);
        if (dropPosition == DropPosition.center) {
          children.add(newDraggedItem);
          DockingTabs newDockingTabs = DockingTabs(children);
          newDockingTabs.selectedIndex = dockingTabs.selectedIndex;
          return newDockingTabs;
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
        DockingRow row = DockingRow(children);
        row.weights = area.weights;
        return row;
      } else if (area is DockingColumn) {
        DockingColumn column = DockingColumn(children);
        column.weights = area.weights;
        return column;
      }
      throw StateError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw StateError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }
}
