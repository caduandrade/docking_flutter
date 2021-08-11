import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/docking_notifier.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingItem].
class DockingItemWidget extends DraggableWidget {
  DockingItemWidget(DockingNotifier model, this.item) : super(model);

  final DockingItem item;

  @override
  State<StatefulWidget> createState() => DockingItemWidgetState();
}

/// The [DockingItemWidget] state.
class DockingItemWidgetState extends DraggableBuilderState<DockingItemWidget> {
  @override
  Widget build(BuildContext context) {
    String name = widget.item.name != null ? widget.item.name! : '';
    List<TabData> tabs = [
      TabData(value: widget.item, text: name, content: widget.item.widget)
    ];
    TabbedViewController controller = TabbedViewController(tabs);

    Widget content = TabbedView(
        onTabClosing: onTabClosing,
        controller: controller,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(widget.item, tabWidget);
        });
    if (widget.model.dragging) {
      return DropWidget.item(widget.model, widget.item, content);
    }
    return content;
  }

  bool onTabClosing(int tabIndex) {
    widget.model.removeItem(widget.item);
    return false;
  }
}
