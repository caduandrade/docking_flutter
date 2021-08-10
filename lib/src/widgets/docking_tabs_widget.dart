import 'package:docking/src/layout/docking_layout.dart';
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
  late TabbedViewController controller;

  @override
  void initState() {
    super.initState();
    List<TabData> tabs = [];
    widget.dockingTabs.forEach((child) {
      tabs.add(TabData(
          value: child,
          text: child.name != null ? child.name! : '',
          content: child.widget));
    });
    controller = TabbedViewController(tabs);
    //print('::: ' + widget.dockingTabs.selectedIndex.toString());
    // controller.selectedIndex = widget.dockingTabs.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TabbedView(
        controller: controller,
        // draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) =>     buildDraggable(tab.value as DockingItem, tabWidget),
        onTabSelection: (int? index) {
          print(index);
          if (index != null) {
            //widget.dockingTabs.selectedIndex = index;
          }
        });

    if (widget.model.dragging) {
      return DropWidget.tabs(widget.model, widget.dockingTabs, content);
    }
    return content;
  }
}
