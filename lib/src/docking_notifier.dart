import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/move_item.dart';
import 'package:docking/src/layout/remove_item.dart';
import 'package:flutter/cupertino.dart';

/// The [Docking] notifier.
class DockingNotifier extends ChangeNotifier {
  DockingNotifier(DockingLayout layout) : this._layout = layout;

  final DockingLayout _layout;

  bool _dragging = false;

  bool get dragging => _dragging;

  set dragging(bool value) {
    _dragging = value;
    notifyListeners();
  }

  void removeItem(DockingItem itemToRemove) {
    _layout.rebuild(RemoveItem(itemToRemove: itemToRemove));
    notifyListeners();
  }

  void moveItem(
      DockingItem draggedItem, DropArea targetArea, DropPosition dropPosition) {
    _layout.rebuild(MoveItem(
        draggedItem: draggedItem,
        targetArea: targetArea,
        dropPosition: dropPosition));
    notifyListeners();
  }
}
