import 'package:docking/docking.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/widgets/docking_item_widget.dart';
import 'package:docking/src/widgets/docking_tabs_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/multi_split_view.dart';

/// The docking widget.
class Docking extends StatefulWidget {
  const Docking({Key? key, required this.layout}) : super(key: key);

  final DockingLayout layout;

  @override
  State<StatefulWidget> createState() => _DockingState();
}

/// The [Docking] state.
class _DockingState extends State<Docking> {
  late DockingModel _model;

  @override
  void initState() {
    super.initState();
    _model = DockingModel(layout: widget.layout);
    _model.addListener(_rebuild);
  }

  @override
  void dispose() {
    _model.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layout.root != null) {
      return DockingAreaWidget(_model, widget.layout.root!);
    }
    return Container();
  }
}

/// Represents a widget for [DockingArea].
class DockingAreaWidget extends StatelessWidget {
  ///Builds a [DockingAreaWidget].
  const DockingAreaWidget(this.model, this.area);

  final DockingModel model;
  final DockingArea area;

  @override
  Widget build(BuildContext context) {
    if (area is DockingItem) {
      return DockingItemWidget(model, area as DockingItem);
    } else if (area is DockingRow) {
      return _row(area as DockingRow);
    } else if (area is DockingColumn) {
      return _column(area as DockingColumn);
    } else if (area is DockingTabs) {
      return DockingTabsWidget(model, area as DockingTabs);
    }
    throw UnimplementedError(
        'Unrecognized runtimeType: ' + area.runtimeType.toString());
  }

  Widget _row(DockingRow row) {
    List<Widget> children = [];
    row.forEach((child) {
      children.add(DockingAreaWidget(model, child));
    });
    return MultiSplitView(children: children, axis: Axis.horizontal);
  }

  Widget _column(DockingColumn column) {
    List<Widget> children = [];
    column.forEach((child) {
      children.add(DockingAreaWidget(model, child));
    });
    return MultiSplitView(children: children, axis: Axis.vertical);
  }
}
