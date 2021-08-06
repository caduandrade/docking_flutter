import 'package:docking/src/docking_layout.dart';
import 'package:docking/src/docking_model.dart';
import 'package:docking/src/widgets/draggable_widget.dart';
import 'package:docking/src/widgets/drop_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingTabs].
class DockingTabsWidget extends DraggableWidget {
  DockingTabsWidget(DockingModel model, this.dockingTabs) : super(model);

  final DockingTabs dockingTabs;

  @override
  State<StatefulWidget> createState() => _DockingTabsWidgetState();
}

/// The [DockingTabsWidget] state.
class _DockingTabsWidgetState extends DraggableBuilderState<DockingTabsWidget> {
  int? lastSelectedTabIndex;
  late TabbedViewController controller;

  @override
  void initState() {
    super.initState();
    if (widget.dockingTabs.childrenCount > 0) {
      lastSelectedTabIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    widget.dockingTabs.forEach((child) {
      tabs.add(TabData(
          value: child,
          text: child.name != null ? child.name! : '',
          content: child.widget));
    });
    TabbedViewController controller = TabbedViewController(tabs);

    if (lastSelectedTabIndex != null &&
        lastSelectedTabIndex! >= widget.dockingTabs.childrenCount &&
        widget.dockingTabs.childrenCount > 0) {
      controller.selectedIndex = widget.dockingTabs.childrenCount - 1;
    } else {
      controller.selectedIndex = null;
    }

    Widget content = TabbedView(
        controller: controller,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) =>
            buildDraggable(tab.value as DockingItem, tabWidget),
        onTabSelection: (int? index) {
          lastSelectedTabIndex = index;
        });

    if (widget.model.dragging) {
      return DropWidget.tabs(widget.model, widget.dockingTabs, content);
    }
    return content;
  }
}
