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
      required this.child,
      this.allowRightEdgeDrop = false})
      : super(key: key);

  final DockingLayout layout;
  final Widget child;
  final DropWidgetListener listener;
  final bool allowRightEdgeDrop;

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    if (!allowRightEdgeDrop) {
      return child;
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(children: [
        Positioned.fill(child: child),
        Positioned(
            child: buildDropAnchor(DropPosition.right),
            width: constraints.maxWidth / 2,
            top: 0,
            bottom: 0,
            right: 0),
      ]);
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
      required Widget child,
      bool allowRightEdgeDrop = false})
      : _dockingItem = dockingItem,
        super(
            layout: layout,
            listener: listener,
            child: child,
            allowRightEdgeDrop: allowRightEdgeDrop);

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
      required Widget child,
      bool allowRightEdgeDrop = false})
      : _dockingTabs = dockingTabs,
        super(
            layout: layout,
            listener: listener,
            child: child,
            allowRightEdgeDrop: allowRightEdgeDrop);

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
