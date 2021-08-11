import 'package:docking/src/docking.dart';
import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/remove_item.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingTabs].
class DockingTabsWidget extends DraggableWidget {
  DockingTabsWidget(
      {Key? key,
      required this.onLayoutModifier,
      required DockingDrag dockingDrag,
      required this.dockingTabs})
      : super(key: key, dockingDrag: dockingDrag);

  final DockingTabs dockingTabs;
  final OnLayoutModifier onLayoutModifier;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    dockingTabs.forEach((child) {
      tabs.add(TabData(
          value: child,
          text: child.name != null ? child.name! : '',
          content: child.widget));
    });
    TabbedViewController controller = TabbedViewController(tabs);

    Widget content = TabbedView(
        controller: controller,
        onTabSelection: (int? index) {
          if (index != null) {
            //widget.dockingTabs.selectedIndex = index;
          }
        },
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(
              dockingTabs.childAt(tabIndex) as DockingItem, tabWidget);
        },
        onTabClosing: _onTabClosing);
    if (dockingDrag.enable) {
      return DropWidget.tabs(onLayoutModifier, dockingTabs, content);
    }
    return content;
  }

  bool _onTabClosing(int tabIndex) {
    onLayoutModifier(
        RemoveItem(itemToRemove: dockingTabs.childAt(tabIndex) as DockingItem));
    return false;
  }
}
