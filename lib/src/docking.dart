import 'package:docking/src/docking_buttons_builder.dart';
import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/on_item_close.dart';
import 'package:docking/src/on_item_selection.dart';
import 'package:docking/src/widgets/docking_item_widget.dart';
import 'package:docking/src/widgets/docking_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/multi_split_view.dart';

/// The docking widget.
class Docking extends StatefulWidget {
  const Docking(
      {Key? key,
      this.layout,
      this.onItemSelection,
      this.onItemClose,
      this.itemCloseInterceptor,
      this.dockingButtonsBuilder,
      this.maximizableItem = true,
      this.maximizableTab = true,
      this.maximizableTabsArea = true,
      this.antiAliasingWorkaround = true})
      : super(key: key);

  final DockingLayout? layout;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;
  final DockingButtonsBuilder? dockingButtonsBuilder;
  final bool maximizableItem;
  final bool maximizableTab;
  final bool maximizableTabsArea;
  final bool antiAliasingWorkaround;

  @override
  State<StatefulWidget> createState() => _DockingState();
}

/// The [Docking] state.
class _DockingState extends State<Docking> {
  final DockingDrag _dockingDrag = DockingDrag();

  @override
  void initState() {
    super.initState();
    _dockingDrag.addListener(_forceRebuild);
    widget.layout?.addListener(_forceRebuild);
  }

  @override
  void dispose() {
    super.dispose();
    _dockingDrag.removeListener(_forceRebuild);
    widget.layout?.removeListener(_forceRebuild);
  }

  @override
  void didUpdateWidget(Docking oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layout != widget.layout) {
      oldWidget.layout?.removeListener(_forceRebuild);
      _dockingDrag.addListener(_forceRebuild);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layout != null) {
      if (widget.layout!.maximizedArea != null) {
        List<DockingArea> areas = widget.layout!.layoutAreas();
        List<Widget> children = [];
        for (DockingArea area in areas) {
          if (area != widget.layout!.maximizedArea!) {
            if (area is DockingItem && area.globalKey != null) {
              // keeping alive other areas
              children.add(ExcludeFocus(
                  child: Offstage(child: _buildArea(context, area))));
            }
          }
        }
        children.add(_buildArea(context, widget.layout!.maximizedArea!));
        return Stack(children: children);
      }
      if (widget.layout!.root != null) {
        return _buildArea(context, widget.layout!.root!);
      }
    }
    return Container();
  }

  Widget _buildArea(BuildContext context, DockingArea area) {
    if (area is DockingItem) {
      return DockingItemWidget(
          layout: widget.layout!,
          dockingDrag: _dockingDrag,
          item: area,
          onItemSelection: widget.onItemSelection,
          itemCloseInterceptor: widget.itemCloseInterceptor,
          onItemClose: widget.onItemClose,
          dockingButtonsBuilder: widget.dockingButtonsBuilder,
          maximizable: widget.maximizableItem);
    } else if (area is DockingRow) {
      return _row(context, area);
    } else if (area is DockingColumn) {
      return _column(context, area);
    } else if (area is DockingTabs) {
      return DockingTabsWidget(
          layout: widget.layout!,
          dockingDrag: _dockingDrag,
          dockingTabs: area,
          onItemSelection: widget.onItemSelection,
          onItemClose: widget.onItemClose,
          itemCloseInterceptor: widget.itemCloseInterceptor,
          dockingButtonsBuilder: widget.dockingButtonsBuilder,
          maximizableTab: widget.maximizableTab,
          maximizableTabsArea: widget.maximizableTabsArea);
    }
    throw UnimplementedError(
        'Unrecognized runtimeType: ' + area.runtimeType.toString());
  }

  Widget _row(BuildContext context, DockingRow row) {
    List<Widget> children = [];
    row.forEach((child) {
      children.add(_buildArea(context, child));
    });

    List<Area> areas = [];
    row.weights.forEach((weight) => areas.add(Area(weight: weight)));
    MultiSplitViewController controller =
        MultiSplitViewController(areas: areas);

    return MultiSplitView(
        children: children,
        axis: Axis.horizontal,
        controller: controller,
        onWeightChange: () {
          row.weights = [];
          controller.areas.forEach((area) => row.weights.add(area.weight!));
        },
        antiAliasingWorkaround: widget.antiAliasingWorkaround);
  }

  Widget _column(BuildContext context, DockingColumn column) {
    List<Widget> children = [];
    column.forEach((child) {
      children.add(_buildArea(context, child));
    });

    List<Area> areas = [];
    column.weights.forEach((weight) => areas.add(Area(weight: weight)));
    MultiSplitViewController controller =
        MultiSplitViewController(areas: areas);

    return MultiSplitView(
        children: children,
        axis: Axis.vertical,
        controller: controller,
        onWeightChange: () {
          column.weights = [];
          controller.areas.forEach((area) => column.weights.add(area.weight!));
        },
        antiAliasingWorkaround: widget.antiAliasingWorkaround);
  }

  void _forceRebuild() {
    setState(() {
      // just rebuild
    });
  }
}
