import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/docking_buttons_builder.dart';
import 'package:docking/src/docking_icons.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/on_item_close.dart';
import 'package:docking/src/on_item_selection.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingItem].
class DockingItemWidget extends DraggableWidget {
  DockingItemWidget(
      {Key? key,
      required this.layout,
      required DockingDrag dockingDrag,
      required this.item,
      this.onItemSelection,
      this.onItemClose,
      this.itemCloseInterceptor,
      this.dockingButtonsBuilder,
      required this.maximizable})
      : super(key: key, dockingDrag: dockingDrag);

  final DockingLayout layout;
  final DockingItem item;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;
  final DockingButtonsBuilder? dockingButtonsBuilder;
  final bool maximizable;

  @override
  Widget build(BuildContext context) {
    String name = item.name != null ? item.name! : '';
    Widget content = item.widget;
    if (item.globalKey != null) {
      content = KeyedSubtree(child: content, key: item.globalKey);
    }
    List<TabButton>? buttons;
    if (item.buttons != null && item.buttons!.isNotEmpty) {
      buttons = [];
      buttons.addAll(item.buttons!);
    }
    if (maximizable) {
      if (buttons == null) {
        buttons = [];
      }
      if (layout.maximizedArea != null && layout.maximizedArea == this.item) {
        buttons.add(TabButton(
            icon: IconProvider.path(DockingIcons.restore),
            onPressed: () => layout.restore()));
      } else {
        buttons.add(TabButton(
            icon: IconProvider.path(DockingIcons.maximize),
            onPressed: () => layout.maximize(item)));
      }
    }

    List<TabData> tabs = [
      TabData(
          value: item,
          text: name,
          content: content,
          closable: item.closable,
          buttons: buttons)
    ];
    TabbedViewController controller = TabbedViewController(tabs);

    OnTabSelection? onTabSelection;
    if (onItemSelection != null) {
      onTabSelection = (int? index) {
        if (index != null) {
          onItemSelection!(item);
        }
      };
    }

    Widget tabbedView = TabbedView(
        tabsAreaButtonsBuilder: _tabsAreaButtonsBuilder,
        onTabSelection: onTabSelection,
        tabCloseInterceptor: _tabCloseInterceptor,
        onTabClose: _onTabClose,
        controller: controller,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(item, tabWidget);
        });
    if (dockingDrag.enable) {
      return DropWidget.item(layout, item, tabbedView);
    }
    return tabbedView;
  }

  List<TabButton> _tabsAreaButtonsBuilder(BuildContext context, int tabsCount) {
    if (dockingButtonsBuilder != null) {
      return dockingButtonsBuilder!(context, null, item);
    }
    return [];
  }

  bool _tabCloseInterceptor(int tabIndex) {
    if (itemCloseInterceptor != null) {
      return itemCloseInterceptor!(item);
    }
    return true;
  }

  void _onTabClose(int tabIndex, TabData tabData) {
    layout.removeItem(item: item);
    if (onItemClose != null) {
      onItemClose!(item);
    }
  }
}
