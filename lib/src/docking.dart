import 'package:docking/src/docking_drag.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_modifier.dart';
import 'package:docking/src/widgets/docking_item_widget.dart';
import 'package:docking/src/widgets/docking_tabs_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/multi_split_view.dart';

/// The docking widget.
class Docking extends StatefulWidget {
  const Docking({Key? key, this.layout}) : super(key: key);

  final DockingLayout? layout;

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
  }

  @override
  void dispose() {
    super.dispose();
    _dockingDrag.removeListener(_forceRebuild);
  }

  void _onLayoutModifier(LayoutModifier modifier) {
    if (widget.layout != null) {
      setState(() {
        widget.layout!.rebuild(modifier);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layout != null && widget.layout!.root != null) {
      return _buildArea(context, widget.layout!.root!);
    }
    return Container();
  }

  Widget _buildArea(BuildContext context, DockingArea area) {
    if (area is DockingItem) {
      return DockingItemWidget(
          dockingDrag: _dockingDrag,
          onLayoutModifier: _onLayoutModifier,
          item: area);
    } else if (area is DockingRow) {
      return _row(context, area);
    } else if (area is DockingColumn) {
      return _column(context, area);
    } else if (area is DockingTabs) {
      return DockingTabsWidget(
          dockingDrag: _dockingDrag,
          onLayoutModifier: _onLayoutModifier,
          dockingTabs: area);
    }
    throw UnimplementedError(
        'Unrecognized runtimeType: ' + area.runtimeType.toString());
  }

  Widget _row(BuildContext context, DockingRow row) {
    List<Widget> children = [];
    row.forEach((child) {
      children.add(_buildArea(context, child));
    });
    return MultiSplitView(children: children, axis: Axis.horizontal);
  }

  Widget _column(BuildContext context, DockingColumn column) {
    List<Widget> children = [];
    column.forEach((child) {
      children.add(_buildArea(context, child));
    });
    return MultiSplitView(children: children, axis: Axis.vertical);
  }

  void _forceRebuild() {
    setState(() {
      // just rebuild
    });
  }
}

typedef OnLayoutModifier = void Function(LayoutModifier modifier);
