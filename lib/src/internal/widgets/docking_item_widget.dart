import 'package:docking/src/docking_buttons_builder.dart';
import 'package:docking/src/drag_over_position.dart';
import 'package:docking/src/internal/widgets/draggable_config_mixin.dart';
import 'package:docking/src/internal/widgets/drop/content_wrapper.dart';
import 'package:docking/src/internal/widgets/drop/drop_feedback_widget.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:docking/src/on_item_close.dart';
import 'package:docking/src/on_item_selection.dart';
import 'package:docking/src/theme/docking_theme.dart';
import 'package:docking/src/theme/docking_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingItem].
@internal
class DockingItemWidget extends StatefulWidget {
  DockingItemWidget(
      {Key? key,
      required this.layout,
      required this.dragOverPosition,
      required this.item,
      this.onItemSelection,
      this.onItemClose,
      this.itemCloseInterceptor,
      this.dockingButtonsBuilder,
      required this.maximizable,
      required this.draggable})
      : super(key: key);

  final DockingLayout layout;
  final DockingItem item;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;
  final DockingButtonsBuilder? dockingButtonsBuilder;
  final bool maximizable;
  final DragOverPosition dragOverPosition;
  final bool draggable;

  @override
  State<StatefulWidget> createState() => DockingItemWidgetState();
}

class DockingItemWidgetState extends State<DockingItemWidget>
    with DraggableConfigMixin {
  DropPosition? _activeDropPosition;

  @override
  Widget build(BuildContext context) {
    String name = widget.item.name != null ? widget.item.name! : '';
    Widget content = widget.item.widget;
    if (widget.item.globalKey != null) {
      content = KeyedSubtree(child: content, key: widget.item.globalKey);
    }
    List<TabButton>? buttons;
    if (widget.item.buttons != null && widget.item.buttons!.isNotEmpty) {
      buttons = [];
      buttons.addAll(widget.item.buttons!);
    }
    final bool maximizable = widget.item.maximizable != null
        ? widget.item.maximizable!
        : widget.maximizable;
    if (maximizable) {
      if (buttons == null) {
        buttons = [];
      }
      DockingThemeData data = DockingTheme.of(context);

      if (widget.layout.maximizedArea != null &&
          widget.layout.maximizedArea == widget.item) {
        buttons.add(TabButton(
            icon: data.restoreIcon, onPressed: () => widget.layout.restore()));
      } else {
        buttons.add(TabButton(
            icon: data.maximizeIcon,
            onPressed: () => widget.layout.maximizeDockingItem(widget.item)));
      }
    }

    List<TabData> tabs = [
      TabData(
          value: widget.item,
          text: name,
          content: content,
          closable: widget.item.closable,
          leading: widget.item.leading,
          buttons: buttons,
          draggable: widget.draggable)
    ];
    TabbedViewController controller = TabbedViewController(tabs);

    OnTabSelection? onTabSelection;
    if (widget.onItemSelection != null) {
      onTabSelection = (int? index) {
        if (index != null) {
          widget.onItemSelection!(widget.item);
        }
      };
    }

    Widget tabbedView = TabbedView(
        tabsAreaButtonsBuilder: _tabsAreaButtonsBuilder,
        onTabSelection: onTabSelection,
        tabCloseInterceptor: _tabCloseInterceptor,
        onTabClose: _onTabClose,
        controller: controller,
        onDraggableBuild: widget.draggable
            ? (TabbedViewController controller, int tabIndex, TabData tabData) {
                return buildDraggableConfig(
                    dockingDrag: widget.dragOverPosition, tabData: tabData);
              }
            : null,
        contentBuilder: (context, tabIndex) => ItemContentWrapper(
            listener: _updateActiveDropPosition,
            layout: widget.layout,
            dockingItem: widget.item,
            child: controller.tabs[tabIndex].content!),
        onBeforeDropAccept: widget.draggable ? _onBeforeDropAccept : null);
    if (widget.draggable && widget.dragOverPosition.enable) {
      return DropFeedbackWidget(
          dropPosition: _activeDropPosition, child: tabbedView);
    }
    return tabbedView;
  }

  bool _onBeforeDropAccept(
      DraggableData source, TabbedViewController target, int newIndex) {
    DockingItem dockingItem = source.tabData.value;
    if (dockingItem != widget.item) {
      widget.layout.moveItem(
          draggedItem: dockingItem,
          targetArea: widget.item,
          dropIndex: newIndex);
    }
    return true;
  }

  void _updateActiveDropPosition(DropPosition? dropPosition) {
    if (_activeDropPosition != dropPosition) {
      setState(() {
        _activeDropPosition = dropPosition;
      });
    }
  }

  List<TabButton> _tabsAreaButtonsBuilder(BuildContext context, int tabsCount) {
    if (widget.dockingButtonsBuilder != null) {
      return widget.dockingButtonsBuilder!(context, null, widget.item);
    }
    return [];
  }

  bool _tabCloseInterceptor(int tabIndex) {
    if (widget.itemCloseInterceptor != null) {
      return widget.itemCloseInterceptor!(widget.item);
    }
    return true;
  }

  void _onTabClose(int tabIndex, TabData tabData) {
    widget.layout.removeItem(item: widget.item);
    if (widget.onItemClose != null) {
      widget.onItemClose!(widget.item);
    }
  }
}
