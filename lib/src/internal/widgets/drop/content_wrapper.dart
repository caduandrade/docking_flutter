import 'package:docking/src/internal/widgets/drop/drop_anchor_widget.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
abstract class ContentWrapperBase extends StatelessWidget {
  const ContentWrapperBase(
      {Key? key,
      required this.layout,
      required this.listener,
      required this.child})
      : super(key: key);

  final DockingLayout layout;
  final Widget child;
  final DropWidgetListener listener;

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      List<Widget> children = [Positioned.fill(child: child)];

      // percentage of width reserved for detecting center area
      const double centerWidthRatio = 50;
      // reserved width to detect center area
      final double centerWidth = centerWidthRatio * constraints.maxWidth / 100;
      // reserved width to detect left and right areas
      final double horizontalEdgeWidth =
          (constraints.maxWidth - centerWidth) / 2;
      // height reserved for detecting the top and bottom areas
      final double verticalEdgeHeight = constraints.maxHeight / 2;

      children.add(Positioned(
          child: buildDropAnchor(DropPosition.left),
          width: horizontalEdgeWidth,
          bottom: 0,
          top: 0,
          left: 0));

      children.add(Positioned(
          child: buildDropAnchor(DropPosition.right),
          width: horizontalEdgeWidth,
          bottom: 0,
          top: 0,
          right: 0));

      children.add(Positioned(
          child: buildDropAnchor(DropPosition.top),
          height: verticalEdgeHeight,
          top: 0,
          left: horizontalEdgeWidth,
          right: horizontalEdgeWidth));

      children.add(Positioned(
          child: buildDropAnchor(DropPosition.bottom),
          height: verticalEdgeHeight,
          bottom: 0,
          left: horizontalEdgeWidth,
          right: horizontalEdgeWidth));

      return Stack(children: children);
    });
  }

  DropAnchorBaseWidget buildDropAnchor(DropPosition dropPosition);
}

@internal
class ItemContentWrapper extends ContentWrapperBase {
  ItemContentWrapper(
      {required DockingLayout layout,
      required DropWidgetListener listener,
      required DockingItem dockingItem,
      required Widget child})
      : _dockingItem = dockingItem,
        super(layout: layout, listener: listener, child: child);

  final DockingItem _dockingItem;

  @override
  DropAnchorBaseWidget buildDropAnchor(DropPosition dropPosition) {
    return ItemDropAnchorWidget(
        layout: layout,
        listener: listener,
        dropPosition: dropPosition,
        dockingItem: _dockingItem);
  }
}

@internal
class TabsContentWrapper extends ContentWrapperBase {
  TabsContentWrapper(
      {required DockingLayout layout,
      required DropWidgetListener listener,
      required DockingTabs dockingTabs,
      required Widget child})
      : _dockingTabs = dockingTabs,
        super(layout: layout, listener: listener, child: child);

  final DockingTabs _dockingTabs;

  @override
  DropAnchorBaseWidget buildDropAnchor(DropPosition dropPosition) {
    return TabsDropAnchorWidget(
        layout: layout,
        listener: listener,
        dropPosition: dropPosition,
        dockingTabs: _dockingTabs);
  }
}
