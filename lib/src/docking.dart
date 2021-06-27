import 'package:docking/src/docking_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// The docking widget.
class Docking extends StatefulWidget {
  const Docking({Key? key, required this.layout}) : super(key: key);

  final DockingLayout layout;

  @override
  State<StatefulWidget> createState() => DockingState();
}

/// The [Docking] state.
class DockingState extends State<Docking> {
  bool _dragging = false;

  bool get dragging => _dragging;

  set dragging(bool value) {
    setState(() {
      _dragging = value;
    });
  }

  /// Gets the [DockingLayout].
  DockingLayout get layout => widget.layout;

  @override
  Widget build(BuildContext context) {
    if (widget.layout.root != null) {
      return _DockingInheritedWidget(
          state: this, child: _DockingAreaWidget(widget.layout.root!));
    }
    return Container();
  }

  static DockingState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_DockingInheritedWidget>()
        ?.state;
  }
}

/// The [InheritedWidget] for [Docking].
class _DockingInheritedWidget extends InheritedWidget {
  /// Builds a [_DockingInheritedWidget].
  _DockingInheritedWidget({required this.state, required Widget child})
      : super(child: child);

  final DockingState state;

  @override
  bool updateShouldNotify(covariant _DockingInheritedWidget oldWidget) => true;
}

/// Represents a widget for [DockingArea].
class _DockingAreaWidget extends StatelessWidget {
  ///Builds a [_DockingAreaWidget].
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
    row.forEach((child) {
      children.add(_DockingAreaWidget(child));
    });
    return MultiSplitView(children: children, axis: Axis.horizontal);
  }

  Widget _column(DockingColumn column) {
    List<Widget> children = [];
    column.forEach((child) {
      children.add(_DockingAreaWidget(child));
    });
    return MultiSplitView(children: children, axis: Axis.vertical);
  }
}

/// Represents a widget for [DockingItem].
class _DockingItemWidget extends StatefulWidget {
  _DockingItemWidget(this.item);

  final DockingItem item;

  @override
  State<StatefulWidget> createState() => _DockingItemWidgetState();
}

/// Abstract state to build a [Draggable].
abstract class _DraggableBuilderState<T extends StatefulWidget>
    extends State<T> {
  Draggable buildDraggable(DockingItem item, Widget child) {
    String name = item.name != null ? item.name! : '';
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
        child: child,
        feedback: buildFeedback(name),
        dragAnchorStrategy: (Draggable<Object> draggable, BuildContext context,
                Offset position) =>
            Offset(20, 20));
  }

  Widget buildFeedback(String name) {
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
                    child: Text(name, overflow: TextOverflow.ellipsis),
                    padding: EdgeInsets.all(4))),
            decoration:
                BoxDecoration(border: Border.all(), color: Colors.grey[300])));
  }
}

/// The [_DockingItemWidget] state.
class _DockingItemWidgetState
    extends _DraggableBuilderState<_DockingItemWidget> {
  @override
  Widget build(BuildContext context) {
    String name = widget.item.name != null ? widget.item.name! : '';
    Widget titleBar = Container(
        child: Text(name), padding: EdgeInsets.all(4), color: Colors.grey[200]);

    Widget content = Container(
        child: Column(children: [
          buildDraggable(widget.item, titleBar),
          Expanded(child: widget.item.widget)
        ], crossAxisAlignment: CrossAxisAlignment.stretch),
        decoration: BoxDecoration(border: Border.all()));

    DockingState state = DockingState.of(context)!;
    if (state.dragging) {
      return _DropWidget.item(widget.item, content);
    }
    return content;
  }
}

/// Represents a widget for [DockingTabs].
class _DockingTabsWidget extends StatefulWidget {
  _DockingTabsWidget(this.dockingTabs);

  final DockingTabs dockingTabs;

  @override
  State<StatefulWidget> createState() => _DockingTabsWidgetState();
}

/// The [_DockingTabsWidget] state.
class _DockingTabsWidgetState
    extends _DraggableBuilderState<_DockingTabsWidget> {
  int? lastSelectedTabIndex;
  late TabbedWiewController controller;

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
    TabbedWiewController controller = TabbedWiewController(tabs);

    if (lastSelectedTabIndex != null &&
        lastSelectedTabIndex! >= widget.dockingTabs.childrenCount &&
        widget.dockingTabs.childrenCount > 0) {
      controller.selectedIndex = widget.dockingTabs.childrenCount - 1;
    } else {
      controller.selectedIndex = null;
    }

    Widget content = TabbedWiew(
        controller: controller,
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) =>
            buildDraggable(tab.value as DockingItem, tabWidget),
        onTabSelection: (int? index) {
          lastSelectedTabIndex = index;
        });

    DockingState state = DockingState.of(context)!;
    if (state.dragging) {
      return _DropWidget.tabs(widget.dockingTabs, content);
    }
    return content;
  }
}

/// Represents a container for [DockingItem] or [DockingTabs] that creates
/// drop areas for a [Draggable].
class _DropWidget extends StatelessWidget {
  const _DropWidget._(this.item, this.tabs, this.areaContent);

  factory _DropWidget.item(DockingItem item, Widget areaContent) {
    return _DropWidget._(item, null, areaContent);
  }

  factory _DropWidget.tabs(DockingTabs tabs, Widget areaContent) {
    return _DropWidget._(null, tabs, areaContent);
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
            child: _DropAnchorWidget(
                item: item, tabs: tabs, position: DropPosition.center))
      ];

      double horizontalEdgeWidth = 30 * constraints.maxWidth / 100;
      double verticalEdgeHeight = 30 * constraints.maxHeight / 100;
      double availableCenterWidth =
          constraints.maxWidth - 2 * horizontalEdgeWidth;
      double availableCenterHeight =
          constraints.maxHeight - 2 * verticalEdgeHeight;

      if (availableCenterWidth >= _minimalSize) {
        children.add(Positioned(
            child: _DropAnchorWidget(
                item: item, tabs: tabs, position: DropPosition.left),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            left: 0));
        children.add(Positioned(
            child: _DropAnchorWidget(
                item: item, tabs: tabs, position: DropPosition.right),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            right: 0));
      }
      if (availableCenterHeight >= _minimalSize) {
        children.add(Positioned(
            child: _DropAnchorWidget(
                item: item, tabs: tabs, position: DropPosition.top),
            height: verticalEdgeHeight,
            top: 0,
            left: 0,
            right: 0));
        children.add(Positioned(
            child: _DropAnchorWidget(
                item: item, tabs: tabs, position: DropPosition.bottom),
            height: verticalEdgeHeight,
            bottom: 0,
            left: 0,
            right: 0));
      }

      return Stack(children: children);
    });
  }
}

class _DropAnchorWidget extends StatelessWidget {
  const _DropAnchorWidget({this.item, this.tabs, required this.position});

  final DockingItem? item;
  final DockingTabs? tabs;
  final DropPosition position;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DockingItem>(
        builder: _buildDropWidget,
        onWillAccept: (DockingItem? data) {
          if (data != null) {
            if (item != null) {
              return item != data;
            }
            if (tabs != null) {
              if (tabs!.contains(data)) {
                return position != DropPosition.center;
              }
              return true;
            }
          }
          return false;
        },
        onAccept: (DockingItem data) {
          DockingState state = DockingState.of(context)!;
          if (item != null) {
            state.layout.move(
                draggedItem: data, targetArea: item!, dropPosition: position);
          } else if (tabs != null) {
            state.layout.move(
                draggedItem: data, targetArea: tabs!, dropPosition: position);
          }
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
