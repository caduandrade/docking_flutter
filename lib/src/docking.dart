import 'package:docking/src/docking_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool _dragging = false;

  bool get dragging => _dragging;

  set dragging(bool value) {
    setState(() {
      _dragging = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _DockingInheritedWidget(
        state: this, child: _DockingAreaWidget(widget.layout.root));
  }

  static DockingState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_DockingInheritedWidget>()
        ?.state;
  }
}

class _DockingInheritedWidget extends InheritedWidget {
  _DockingInheritedWidget({required this.state, required Widget child})
      : super(child: child);

  final DockingState state;

  @override
  bool updateShouldNotify(covariant _DockingInheritedWidget oldWidget) => true;
}

class _DockingAreaWidget extends StatelessWidget {
  const _DockingAreaWidget(this.area);

  final DockingArea area;

  @override
  Widget build(BuildContext context) {
    if (area is DockingItem) {
      return _DockingItemWidget(area as DockingItem);
    } else if (area is DockingRow) {
      return _row(area as DockingRow);
    } else if (area is DockingColumn) {
      return _column(area as DockingColumn);
    } else if (area is DockingTabs) {
      return _DockingTabsWidget(area as DockingTabs);
    }
    throw UnimplementedError(
        'Unrecognized runtimeType: ' + area.runtimeType.toString());
  }

  Widget _row(DockingRow row) {
    List<Widget> children = [];
    for (DockingArea item in row.children) {
      children.add(_DockingAreaWidget(item));
    }
    return MultiSplitView(children: children, axis: Axis.horizontal);
  }

  Widget _column(DockingColumn column) {
    List<Widget> children = [];
    for (DockingArea area in column.children) {
      children.add(_DockingAreaWidget(area));
    }
    return MultiSplitView(children: children, axis: Axis.vertical);
  }
}

class _DockingItemWidget extends StatelessWidget {
  _DockingItemWidget(this.item);

  final DockingItem item;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
        child: Column(
            children: [_buildTitleBar(context), Expanded(child: item.widget)],
            crossAxisAlignment: CrossAxisAlignment.stretch),
        decoration: BoxDecoration(border: Border.all()));

    DockingState state = DockingState.of(context)!;
    if (state.dragging) {
      return _DropAreaWidget.item(item, content);
    }
    return content;
  }

  Widget _buildTitleBar(BuildContext context) {
    return Draggable<DockingItem>(
        data: item,
        onDragStarted: () {
          print('onDragStarted');
          DockingState state = DockingState.of(context)!;
          state.dragging = true;
        },
        onDragCompleted: () {
          print('onDragCompleted');
          DockingState state = DockingState.of(context)!;
          state.dragging = false;
        },
        onDragEnd: (details) {
          print('onDragEnd');
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          print('onDraggableCanceled');
        },
        child: Container(
            child: Text(item.name != null ? item.name! : ''),
            padding: EdgeInsets.all(4),
            color: Colors.grey[200]),
        feedback: _draggableFeedback(),
        dragAnchorStrategy: (Draggable<Object> draggable, BuildContext context,
                Offset position) =>
            Offset(20, 20));
  }

  _draggableFeedback() {
    return Material(
        child: Container(
            child: ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 0,
                  minWidth: 30,
                  maxHeight: double.infinity,
                  maxWidth: 150.0,
                ),
                child: Padding(
                    child: Text(item.name != null ? item.name! : '',
                        overflow: TextOverflow.ellipsis),
                    padding: EdgeInsets.all(4))),
            decoration:
                BoxDecoration(border: Border.all(), color: Colors.grey[300])));
  }
}

class _DockingTabsWidget extends StatelessWidget {
  const _DockingTabsWidget(this.dockingTabs);

  final DockingTabs dockingTabs;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    for (DockingItem dockingChild in dockingTabs.children) {
      tabs.add(TabData(
          text: dockingChild.name != null ? dockingChild.name! : '',
          content: dockingChild.widget));
    }
    TabbedWiew content = TabbedWiew(controller: TabbedWiewController(tabs));

    DockingState state = DockingState.of(context)!;
    if (state.dragging) {
      return _DropAreaWidget.tabs(dockingTabs, content);
    }
    return content;
  }
}

class _DropAreaWidget extends StatelessWidget {
  const _DropAreaWidget._(this.item, this.tabs, this.areaContent);

  factory _DropAreaWidget.item(DockingItem item, Widget areaContent) {
    return _DropAreaWidget._(item, null, areaContent);
  }

  factory _DropAreaWidget.tabs(DockingTabs tabs, Widget areaContent) {
    return _DropAreaWidget._(null, tabs, areaContent);
  }

  static const double _minimalSize = 30;

  final DockingItem? item;
  final DockingTabs? tabs;
  final Widget areaContent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      List<Widget> children = [
        Positioned.fill(child: areaContent),
        Positioned.fill(
            child: _DropAnchorAreaWidget(
                item: item, tabs: tabs, anchor: _DropAnchor.center))
      ];

      double horizontalEdgeWidth = 30 * constraints.maxWidth / 100;
      double verticalEdgeHeight = 30 * constraints.maxHeight / 100;
      double availableCenterWidth =
          constraints.maxWidth - 2 * horizontalEdgeWidth;
      double availableCenterHeight =
          constraints.maxHeight - 2 * verticalEdgeHeight;

      if (availableCenterWidth >= _minimalSize) {
        children.add(Positioned(
            child: _DropAnchorAreaWidget(
                item: item, tabs: tabs, anchor: _DropAnchor.left),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            left: 0));
        children.add(Positioned(
            child: _DropAnchorAreaWidget(
                item: item, tabs: tabs, anchor: _DropAnchor.right),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            right: 0));
      }
      if (availableCenterHeight >= _minimalSize) {
        children.add(Positioned(
            child: _DropAnchorAreaWidget(
                item: item, tabs: tabs, anchor: _DropAnchor.top),
            height: verticalEdgeHeight,
            top: 0,
            left: 0,
            right: 0));
        children.add(Positioned(
            child: _DropAnchorAreaWidget(
                item: item, tabs: tabs, anchor: _DropAnchor.bottom),
            height: verticalEdgeHeight,
            bottom: 0,
            left: 0,
            right: 0));
      }

      return Stack(children: children);
    });
  }
}

enum _DropAnchor { top, bottom, left, right, center }

class _DropAnchorAreaWidget extends StatelessWidget {
  const _DropAnchorAreaWidget({this.item, this.tabs, required this.anchor});

  final DockingItem? item;
  final DockingTabs? tabs;
  final _DropAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DockingItem>(
        builder: _buildDropWidget,
        onWillAccept: (DockingItem? data) {
          return data != null && item != data;
        });
  }

  Widget _buildDropWidget(BuildContext context,
      List<DockingItem?> candidateData, List<dynamic> rejectedData) {
    Color? color;
    if (candidateData.isNotEmpty) {
      color = Colors.black.withOpacity(.5);
    }
    return Container(color: color);
  }
}
