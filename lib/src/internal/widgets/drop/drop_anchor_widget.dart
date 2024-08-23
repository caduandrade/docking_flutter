import 'package:docking/src/internal/debug.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/tabbed_view.dart';

typedef DropWidgetListener = void Function(DropPosition? dropPosition);

@internal
abstract class DropAnchorBaseWidget extends StatelessWidget {
  const DropAnchorBaseWidget(
      {required this.layout,
      required this.dropPosition,
      required this.listener});

  final DockingLayout layout;
  final DropPosition dropPosition;
  final DropWidgetListener listener;

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        onExit: (e) => listener(null),
        child: DragTarget<DraggableData>(
            builder: _buildDropWidget,
            onWillAcceptWithDetails:
                (DragTargetDetails<DraggableData> details) {
              final DraggableData draggableData = details.data;
              final TabData? draggedTabData = draggableData.tabData;
              final DockingItem? draggedItem = draggedTabData?.value;
              if (draggedItem != null) {
                bool willAccept = onWillAccept(draggedItem);
                if (willAccept) {
                  listener(dropPosition);
                } else {
                  listener(null);
                }
                return willAccept;
              } else {
                listener(null);
              }
              return false;
            },
            onAcceptWithDetails: (DragTargetDetails<DraggableData> details) {
              final DraggableData draggableData = details.data;
              final TabData tabData = draggableData.tabData;
              final DockingItem draggableItem = tabData.value;
              onAccept(draggableItem);
            }));
  }

  bool onWillAccept(DockingItem draggedItem);

  void onAccept(DockingItem draggedItem);

  Widget _buildDropWidget(BuildContext context,
      List<DraggableData?> candidateTabData, List<dynamic> rejectedData) {
    if (DockingDebug.dropAreaVisible) {
      Color color = Colors.deepOrange;
      if (dropPosition == DropPosition.top) {
        color = Colors.blue;
      } else if (dropPosition == DropPosition.bottom) {
        color = Colors.green;
      } else if (dropPosition == DropPosition.left) {
        color = Colors.purple;
      }
      return Container(child: Placeholder(color: color));
    }
    return Container();
  }
}

@internal
class ItemDropAnchorWidget extends DropAnchorBaseWidget {
  const ItemDropAnchorWidget(
      {required DockingLayout layout,
      required DropPosition dropPosition,
      required DropWidgetListener listener,
      required DockingItem dockingItem})
      : _dockingItem = dockingItem,
        super(layout: layout, dropPosition: dropPosition, listener: listener);

  final DockingItem _dockingItem;

  @override
  void onAccept(DockingItem draggedItem) {
    layout.moveItem(
        draggedItem: draggedItem,
        targetArea: _dockingItem,
        dropPosition: dropPosition);
  }

  @override
  bool onWillAccept(DockingItem draggedItem) {
    return _dockingItem != draggedItem;
  }
}

@internal
class TabsDropAnchorWidget extends DropAnchorBaseWidget {
  const TabsDropAnchorWidget(
      {required DockingLayout layout,
      required DropPosition dropPosition,
      required DropWidgetListener listener,
      required DockingTabs dockingTabs})
      : _dockingTabs = dockingTabs,
        super(layout: layout, dropPosition: dropPosition, listener: listener);

  final DockingTabs _dockingTabs;

  @override
  void onAccept(DockingItem draggedItem) {
    layout.moveItem(
        draggedItem: draggedItem,
        targetArea: _dockingTabs,
        dropPosition: dropPosition);
  }

  @override
  bool onWillAccept(DockingItem draggedItem) {
    return true;
  }
}
