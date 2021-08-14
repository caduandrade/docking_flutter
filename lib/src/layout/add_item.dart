import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_modifier.dart';

/// Removes a [DockingItem] from this layout.
class RemoveItem extends LayoutModifier {
  RemoveItem({required this.itemToRemove});

  final DockingItem itemToRemove;

  @override
  DockingArea? newLayout(DockingLayout layout) {
    validate(layout.id, itemToRemove);
    if (layout.root != null) {
      return _buildLayout(layout.root!);
    }
    return null;
  }

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
      return DockingTabs(children);
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
      throw ArgumentError(
          'DockingArea class not recognized: ' + area.runtimeType.toString());
    }
    throw ArgumentError(
        'DockingArea class not recognized: ' + area.runtimeType.toString());
  }
}
