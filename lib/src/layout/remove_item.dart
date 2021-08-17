import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_modifier.dart';

/// Removes [DockingItem] from this layout.
class RemoveItem extends LayoutModifier {
  RemoveItem({required this.itemToRemove});

  final DockingItem itemToRemove;

  @override
  void validate(DockingLayout layout, DockingArea area) {
    super.validate(layout, area);
    if (area.layoutId != layout.id) {
      throw ArgumentError(
          'DockingArea belongs to another layout. Keep the layout in the state of your StatefulWidget.');
    }
  }

  @override
  DockingArea? newLayout(DockingLayout layout) {
    validate(layout, itemToRemove);
    if (layout.root != null) {
      return _buildLayout(layout.root!);
    }
    return null;
  }

  /// Builds a new root.
  DockingArea? _buildLayout(DockingArea area) {
    if (area is DockingItem) {
      DockingItem dockingItem = area;
      if (dockingItem == itemToRemove) {
        return null;
      }
      return DockingItem.clone(dockingItem);
    } else if (area is DockingTabs) {
      DockingTabs dockingTabs = area;
      List<DockingItem> children = [];
      dockingTabs.forEach((child) {
        if (child != itemToRemove) {
          children.add(DockingItem.clone(child));
        }
      });
      if (children.length == 1) {
        return children.first;
      }
      DockingTabs newDockingTabs = DockingTabs(children);
      newDockingTabs.selectedIndex = dockingTabs.selectedIndex;
      return newDockingTabs;
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
      throw ArgumentError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw ArgumentError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }
}
