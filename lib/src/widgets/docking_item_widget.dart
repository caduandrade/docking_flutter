import 'package:docking/src/docking.dart';
import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/remove_item.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingItem].
class DockingItemWidget extends DraggableWidget {
  DockingItemWidget(
      {Key? key,
      required this.onLayoutModifier,
      required DockingDrag dockingDrag,
      required this.item})
      : super(key: key, dockingDrag: dockingDrag);

  final DockingItem item;
  final OnLayoutModifier onLayoutModifier;

  @override
  Widget build(BuildContext context) {
    String name = item.name != null ? item.name! : '';
    List<TabData> tabs = [
      TabData(value: item, text: name, content: item.widget)
    ];
    TabbedViewController controller = TabbedViewController(tabs);

    Widget content = TabbedView(
        onTabClosing: _onTabClosing,
        controller: controller,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(item, tabWidget);
        });
    if (dockingDrag.enable) {
      return DropWidget.item(onLayoutModifier, item, content);
    }
    return content;
  }

  bool _onTabClosing(int tabIndex) {
    onLayoutModifier(RemoveItem(itemToRemove: item));
    return false;
  }
}
