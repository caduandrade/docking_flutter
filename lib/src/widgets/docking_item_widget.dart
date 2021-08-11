import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/docking_notifier.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingItem].
class DockingItemWidget extends DraggableWidget {
  DockingItemWidget(
      {Key? key, required DockingNotifier notifier, required this.item})
      : super(key: key, notifier: notifier);

  final DockingItem item;

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
    if (notifier.dragging) {
      return DropWidget.item(notifier, item, content);
    }
    return content;
  }

  bool _onTabClosing(int tabIndex) {
    notifier.removeItem(item);
    return false;
  }
}
