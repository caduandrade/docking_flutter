import 'dart:math' as math;
import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/docking_buttons_builder.dart';
import 'package:docking/src/docking_icons.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/on_item_close.dart';
import 'package:docking/src/on_item_selection.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingTabs].
class DockingTabsWidget extends DraggableWidget {
  DockingTabsWidget(
      {Key? key,
      required this.layout,
      required DockingDrag dockingDrag,
      required this.dockingTabs,
      this.onItemSelection,
      this.onItemClose,
      this.itemCloseInterceptor,
      this.dockingButtonsBuilder,
      required this.maximizableTab,
      required this.maximizableTabsArea})
      : super(key: key, dockingDrag: dockingDrag);

  final DockingLayout layout;
  final DockingTabs dockingTabs;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;
  final DockingButtonsBuilder? dockingButtonsBuilder;
  final bool maximizableTab;
  final bool maximizableTabsArea;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    dockingTabs.forEach((child) {
      Widget content = child.widget;
      if (child.globalKey != null) {
        content = KeyedSubtree(child: content, key: child.globalKey);
      }
      List<TabButton>? buttons;
      if (child.buttons != null && child.buttons!.isNotEmpty) {
        buttons = [];
        buttons.addAll(child.buttons!);
      }
      final bool maximizable =
          child.maximizable != null ? child.maximizable! : this.maximizableTab;
      if (maximizable) {
        if (buttons == null) {
          buttons = [];
        }
        if (layout.maximizedArea != null && layout.maximizedArea == child) {
          buttons.add(TabButton(
              icon: IconProvider.path(DockingIcons.restore),
              onPressed: () => layout.restore()));
        } else {
          buttons.add(TabButton(
              icon: IconProvider.data(Icons.web_asset_sharp),
              onPressed: () => layout.maximizeDockingItem(child)));
        }
      }
      tabs.add(TabData(
          value: child,
          text: child.name != null ? child.name! : '',
          content: content,
          closable: child.closable,
          keepAlive: child.globalKey != null,
          buttons: buttons));
    });
    TabbedViewController controller = TabbedViewController(tabs);
    controller.selectedIndex =
        math.min(dockingTabs.selectedIndex, tabs.length - 1);

    Widget tabbedView = TabbedView(
        controller: controller,
        tabsAreaButtonsBuilder: _tabsAreaButtonsBuilder,
        onTabSelection: (int? index) {
          if (index != null) {
            dockingTabs.selectedIndex = index;
            if (onItemSelection != null) {
              onItemSelection!(dockingTabs.childAt(index));
            }
          }
        },
        tabCloseInterceptor: _tabCloseInterceptor,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(dockingTabs.childAt(tabIndex), tabWidget);
        },
        onTabClose: _onTabClose);
    if (dockingDrag.enable) {
      return DropWidget.tabs(layout, dockingTabs, tabbedView);
    }
    return tabbedView;
  }

  List<TabButton> _tabsAreaButtonsBuilder(BuildContext context, int tabsCount) {
    List<TabButton> buttons = [];
    if (dockingButtonsBuilder != null) {
      buttons.addAll(dockingButtonsBuilder!(context, dockingTabs, null));
    }
    final bool maximizable = dockingTabs.maximizable != null
        ? dockingTabs.maximizable!
        : this.maximizableTabsArea;
    if (maximizable) {
      if (layout.maximizedArea != null && layout.maximizedArea == dockingTabs) {
        buttons.add(TabButton(
            icon: IconProvider.path(DockingIcons.restore),
            onPressed: () => layout.restore()));
      } else {
        buttons.add(TabButton(
            icon: IconProvider.data(Icons.web_asset_sharp),
            onPressed: () => layout.maximizeDockingTabs(dockingTabs)));
      }
    }
    return buttons;
  }

  bool _tabCloseInterceptor(int tabIndex) {
    if (itemCloseInterceptor != null) {
      return itemCloseInterceptor!(dockingTabs.childAt(tabIndex));
    }
    return true;
  }

  void _onTabClose(int tabIndex, TabData tabData) {
    DockingItem dockingItem = dockingTabs.childAt(tabIndex);
    layout.removeItem(item: dockingItem);
    if (onItemClose != null) {
      onItemClose!(dockingItem);
    }
  }
}
