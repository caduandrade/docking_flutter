import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents a abstract draggable widget.
abstract class DraggableWidget extends StatelessWidget {
  DraggableWidget({Key? key, required this.dockingDrag}) : super(key: key);

  final DockingDrag dockingDrag;
  Draggable buildDraggable(DockingItem item, Widget child) {
    String name = item.name != null ? item.name! : '';
    return Draggable<DockingItem>(
        data: item,
        onDragStarted: () {
          dockingDrag.enable = true;
        },
        onDragCompleted: () {
          dockingDrag.enable = false;
        },
        onDragEnd: (details) {},
        onDraggableCanceled: (Velocity velocity, Offset offset) {},
        child: child,
        feedback: buildFeedback(name),
        dragAnchorStrategy: (Draggable<Object> draggable, BuildContext context,
                Offset position) =>
            Offset(20, 20));
  }

  Widget buildFeedback(String name) {
    return Material(
        child: Container(
            child: ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 0,
                  minWidth: 30,
                  maxHeight: double.infinity,
                  maxWidth: 150.0,
                ),
                child: Padding(
                    child: Text(name, overflow: TextOverflow.ellipsis),
                    padding: EdgeInsets.all(4))),
            decoration:
                BoxDecoration(border: Border.all(), color: Colors.grey[300])));
  }
}
