import 'package:docking/src/layout/docking_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents a container for [DockingItem] or [DockingTabs] that creates
/// drop areas for a [Draggable].
class DropWidget extends StatelessWidget {
  const DropWidget._(this.layout, this.item, this.tabs, this.areaContent);

  factory DropWidget.item(
      DockingLayout layout, DockingItem item, Widget areaContent) {
    return DropWidget._(layout, item, null, areaContent);
  }

  factory DropWidget.tabs(
      DockingLayout layout, DockingTabs tabs, Widget areaContent) {
    return DropWidget._(layout, null, tabs, areaContent);
  }

  static const double _minimalSize = 30;

  final DockingLayout layout;
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
                layout: layout,
                dockingItem: item,
                dockingTabs: tabs,
                dropPosition: DropPosition.center))
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
                layout: layout,
                dockingItem: item,
                dockingTabs: tabs,
                dropPosition: DropPosition.left),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            left: 0));
        children.add(Positioned(
            child: _DropAnchorWidget(
                layout: layout,
                dockingItem: item,
                dockingTabs: tabs,
                dropPosition: DropPosition.right),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            right: 0));
      }
      if (availableCenterHeight >= _minimalSize) {
        children.add(Positioned(
            child: _DropAnchorWidget(
                layout: layout,
                dockingItem: item,
                dockingTabs: tabs,
                dropPosition: DropPosition.top),
            height: verticalEdgeHeight,
            top: 0,
            left: 0,
            right: 0));
        children.add(Positioned(
            child: _DropAnchorWidget(
                layout: layout,
                dockingItem: item,
                dockingTabs: tabs,
                dropPosition: DropPosition.bottom),
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
  const _DropAnchorWidget(
      {required this.layout,
      this.dockingItem,
      this.dockingTabs,
      required this.dropPosition});

  final DockingLayout layout;
  final DockingItem? dockingItem;
  final DockingTabs? dockingTabs;
  final DropPosition dropPosition;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DockingItem>(
        builder: _buildDropWidget,
        onWillAccept: (DockingItem? data) {
          if (data != null) {
            if (dockingItem != null) {
              return dockingItem != data;
            }
            if (dockingTabs != null) {
              if (dockingTabs!.contains(data)) {
                return dropPosition != DropPosition.center;
              }
              return true;
            }
          }
          return false;
        },
        onAccept: (DockingItem data) {
          if (dockingItem != null) {
            layout.moveItem(
                draggedItem: data,
                targetArea: dockingItem!,
                dropPosition: dropPosition);
          } else if (dockingTabs != null) {
            layout.moveItem(
                draggedItem: data,
                targetArea: dockingTabs!,
                dropPosition: dropPosition);
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
