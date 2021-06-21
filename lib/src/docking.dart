import 'package:docking/src/docking_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:tabbed_view/tabbed_view.dart';

class Docking extends StatefulWidget {
  const Docking({Key? key, required this.layout}) : super(key: key);

  final DockingLayout layout;

  @override
  State<StatefulWidget> createState() => DockingState();
}

class DockingState extends State<Docking> {
  @override
  Widget build(BuildContext context) {
    return (_DockingArea.dockingAreaOf(widget.layout.root));
  }
}

abstract class _DockingArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context);

  static _DockingArea dockingAreaOf(DockingLayoutItem item) {
    if (item is DockingWidget) {
      return _DockingWidgetArea(item);
    } else if (item is DockingRow) {
      return _DockingRowArea(item);
    } else if (item is DockingColumn) {
      return _DockingColumnArea(item);
    } else if (item is DockingTabs) {
      return _DockingTabsArea(item);
    }
    throw UnimplementedError(
        'Unrecognized runtimeType: ' + item.runtimeType.toString());
  }
}

class _DockingWidgetArea extends _DockingArea {
  _DockingWidgetArea(this.dockingWidget);

  final DockingWidget dockingWidget;

  @override
  Widget _build(BuildContext context) {
    return Container(
        child: Column(
            children: [_buildTitleBar(), Expanded(child: dockingWidget.widget)],
            crossAxisAlignment: CrossAxisAlignment.stretch),
        decoration: BoxDecoration(border: Border.all()));
  }

  Widget _buildTitleBar() {
    return Container(
        child: Text(dockingWidget.name != null ? dockingWidget.name! : ''),
        padding: EdgeInsets.all(4),
        color: Colors.grey[200]);
  }
}

class _DockingRowArea extends _DockingArea {
  _DockingRowArea(this.row);

  final DockingRow row;

  @override
  Widget _build(BuildContext context) {
    List<Widget> children = [];
    for (DockingLayoutItem item in row.children) {
      children.add(_DockingArea.dockingAreaOf(item));
    }
    return MultiSplitView(children: children, axis: Axis.horizontal);
  }
}

class _DockingColumnArea extends _DockingArea {
  _DockingColumnArea(this.column);

  final DockingColumn column;

  @override
  Widget _build(BuildContext context) {
    List<Widget> children = [];
    for (DockingLayoutItem item in column.children) {
      children.add(_DockingArea.dockingAreaOf(item));
    }
    return MultiSplitView(children: children, axis: Axis.vertical);
  }
}

class _DockingTabsArea extends _DockingArea {
  _DockingTabsArea(this.dockingTabs);

  final DockingTabs dockingTabs;

  @override
  Widget _build(BuildContext context) {
    List<TabData> tabs = [];
    for (DockingWidget dockingChild in dockingTabs.children) {
      tabs.add(TabData(
          text: dockingChild.name != null ? dockingChild.name! : '',
          content: dockingChild.widget));
    }
    return TabbedWiew(controller: TabbedWiewController(tabs));
  }
}
