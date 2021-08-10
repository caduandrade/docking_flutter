import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/docking_model.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents a widget for [DockingItem].
class DockingItemWidget extends DraggableWidget {
  DockingItemWidget(DockingModel model, this.item) : super(model);

  final DockingItem item;

  @override
  State<StatefulWidget> createState() => DockingItemWidgetState();
}

/// The [DockingItemWidget] state.
class DockingItemWidgetState extends DraggableBuilderState<DockingItemWidget> {
  @override
  Widget build(BuildContext context) {
    String name = widget.item.name != null ? widget.item.name! : '';
    Widget titleBar = Container(
        child: Text(name), padding: EdgeInsets.all(4), color: Colors.grey[200]);

    Widget content = Container(
        child: Column(children: [
          buildDraggable(widget.item, titleBar),
          Expanded(child: widget.item.widget)
        ], crossAxisAlignment: CrossAxisAlignment.stretch),
        decoration: BoxDecoration(border: Border.all()));

    if (widget.model.dragging) {
      return DropWidget.item(widget.model, widget.item, content);
    }
    return content;
  }
}
