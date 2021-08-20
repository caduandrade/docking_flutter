import 'package:docking/src/docking_drag.dart';
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
      this.itemCloseInterceptor})
      : super(key: key, dockingDrag: dockingDrag);

  final DockingLayout layout;
  final DockingItem item;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;

  @override
  Widget build(BuildContext context) {
    String name = item.name != null ? item.name! : '';
    List<TabData> tabs = [
      TabData(
          value: item,
          text: name,
          content: item.widget,
          closable: item.closable,
      buttons: item.buttons)
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

    Widget content = TabbedView(
        onTabSelection: onTabSelection,
        tabCloseInterceptor: _tabCloseInterceptor,
        onTabClose: _onTabClose,
        controller: controller,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return buildDraggable(item, tabWidget);
        });
    if (dockingDrag.enable) {
      return DropWidget.item(layout, item, content);
    }
    return content;
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
