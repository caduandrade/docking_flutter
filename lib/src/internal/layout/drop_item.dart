import 'package:docking/src/internal/layout/layout_modifier.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:meta/meta.dart';

/// Drops a [DockingItem] in the layout.
@internal
class DropItem extends LayoutModifier {
  DropItem(
      {required this.dropItem,
      required this.targetArea,
      required this.dropPosition,
      required this.dropIndex}) {
    if ((dropIndex == null && dropPosition == null) ||
        (dropIndex != null && dropPosition != null)) {
      throw ArgumentError(
          'Only one of the dropIndex and dropPosition parameters can be set.');
    }
  }

  final DockingItem dropItem;
  final DropArea targetArea;
  final DropPosition? dropPosition;
  final int? dropIndex;

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
      final DockingItem dockingItem = area;
      if (dockingItem == dropItem && dockingItem == targetArea) {
        throw StateError('DockingItem is dragged and target at same time.');
      } else if (dockingItem == dropItem) {
        // ignore
        return null;
      } else if (dockingItem == targetArea) {
        final DockingItem newDraggedItem = dropItem;
        if (dropIndex == 0) {
          return DockingTabs([newDraggedItem, dockingItem],
              weight: dockingItem.weight,
              minimalSize: dockingItem.minimalSize,
              minimalWeight: dockingItem.minimalWeight);
        } else if (dropIndex == 1) {
          return DockingTabs([dockingItem, newDraggedItem],
              weight: dockingItem.weight,
              minimalSize: dockingItem.minimalSize,
              minimalWeight: dockingItem.minimalWeight);
        } else if (dropPosition == DropPosition.top) {
          return DockingColumn([newDraggedItem, dockingItem],
              weight: dockingItem.weight,
              minimalSize: dockingItem.minimalSize,
              minimalWeight: dockingItem.minimalWeight);
        } else if (dropPosition == DropPosition.bottom) {
          return DockingColumn([dockingItem, newDraggedItem],
              weight: dockingItem.weight,
              minimalSize: dockingItem.minimalSize,
              minimalWeight: dockingItem.minimalWeight);
        } else if (dropPosition == DropPosition.left) {
          return DockingRow([newDraggedItem, dockingItem],
              weight: dockingItem.weight,
              minimalSize: dockingItem.minimalSize,
              minimalWeight: dockingItem.minimalWeight);
        } else if (dropPosition == DropPosition.right) {
          return DockingRow([dockingItem, newDraggedItem],
              weight: dockingItem.weight,
              minimalSize: dockingItem.minimalSize,
              minimalWeight: dockingItem.minimalWeight);
        } else {
          throw ArgumentError(
              'DropPosition not recognized: ' + dropPosition.toString());
        }
      }
      return area;
    } else if (area is DockingTabs) {
      final DockingTabs dockingTabs = area;
      List<DockingItem> children = [];
      DockingItem? oldSelection;
      int oldIndex = -1;
      for (int index = 0; index < dockingTabs.childrenCount; index++) {
        DockingItem child = dockingTabs.childAt(index);
        if (child == targetArea) {
          throw ArgumentError('Nested tabbed panels are not allowed.');
        }
        if (child != dropItem) {
          children.add(child);
        } else {
          oldIndex = index;
        }
        if (index == dockingTabs.selectedIndex) {
          oldSelection = child;
        }
      }
      final DockingArea? newArea;
      if (children.length == 1) {
        newArea = children.first;
      } else {
        newArea = DockingTabs(children,
            id: dockingTabs.id,
            maximized: dockingTabs.maximized,
            maximizable: dockingTabs.maximizable,
            weight: dockingTabs.weight,
            minimalWeight: dockingTabs.minimalWeight,
            minimalSize: dockingTabs.minimalSize);
        if (oldSelection != null) {
          int newSelectedIndex = children.indexOf(oldSelection);
          (newArea as DockingTabs).selectedIndex =
              newSelectedIndex > -1 ? newSelectedIndex : 0;
        }
      }
      if (dockingTabs == targetArea) {
        DockingItem newDraggedItem = dropItem;
        if (dropIndex != null) {
          int newIndex = dropIndex!;
          if (oldIndex > -1) {
            if (newIndex > 0) {
              newIndex--;
            }
            children.insert(newIndex, newDraggedItem);
          } else {
            children.insert(newIndex, newDraggedItem);
          }
          DockingTabs newDockingTabs = DockingTabs(children,
              id: dockingTabs.id,
              maximized: dockingTabs.maximized,
              maximizable: dockingTabs.maximizable,
              weight: dockingTabs.weight,
              minimalWeight: dockingTabs.minimalWeight,
              minimalSize: dockingTabs.minimalSize);
          if (oldSelection != null) {
            int newSelectedIndex = children.indexOf(oldSelection);
            newDockingTabs.selectedIndex =
                newSelectedIndex > -1 ? newSelectedIndex : 0;
          }
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
        return DockingRow(children,
            weight: area.weight,
            minimalWeight: area.minimalWeight,
            minimalSize: area.minimalSize);
      } else if (area is DockingColumn) {
        return DockingColumn(children,
            weight: area.weight,
            minimalWeight: area.minimalWeight,
            minimalSize: area.minimalSize);
      }
      throw StateError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw StateError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }
}
