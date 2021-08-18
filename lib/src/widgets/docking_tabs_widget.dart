import 'dart:math' as math;
import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingTabs].
class DockingTabsWidget extends DraggableWidget {
  DockingTabsWidget(
      {Key? key,
      required this.layout,
      required DockingDrag dockingDrag,
      required this.dockingTabs})
      : super(key: key, dockingDrag: dockingDrag);

  final DockingLayout layout;
  final DockingTabs dockingTabs;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    dockingTabs.forEach((child) {
      tabs.add(TabData(
          value: child,
          text: child.name != null ? child.name! : '',
          content: child.widget,
          closable: child.closable,
          keepAlive: true));
    });
    TabbedViewController controller = TabbedViewController(tabs);
    controller.selectedIndex =
        math.min(dockingTabs.selectedIndex, tabs.length - 1);

    Widget content = TabbedView(
        controller: controller,
        onTabSelection: (int? index) {
          if (index != null) {
            dockingTabs.selectedIndex = index;
          }
        },
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(
              dockingTabs.childAt(tabIndex) as DockingItem, tabWidget);
        },
        onTabClosing: _onTabClosing);
    if (dockingDrag.enable) {
      return DropWidget.tabs(layout, dockingTabs, content);
    }
    return content;
  }

  bool _onTabClosing(int tabIndex) {
    layout.removeItem(item: dockingTabs.childAt(tabIndex) as DockingItem);
    return false;
  }
}
