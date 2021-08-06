import 'package:docking/docking.dart';
import 'package:docking/src/docking_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents a container for [DockingItem] or [DockingTabs] that creates
/// drop areas for a [Draggable].
class DropWidget extends StatelessWidget {
  const DropWidget._(this.model, this.item, this.tabs, this.areaContent);

  factory DropWidget.item(
      DockingModel model, DockingItem item, Widget areaContent) {
    return DropWidget._(model, item, null, areaContent);
  }

  factory DropWidget.tabs(
      DockingModel model, DockingTabs tabs, Widget areaContent) {
    return DropWidget._(model, null, tabs, areaContent);
  }

  static const double _minimalSize = 30;

  final DockingModel model;
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
                model: model,
                item: item,
                tabs: tabs,
                position: DropPosition.center))
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
                model: model,
                item: item,
                tabs: tabs,
                position: DropPosition.left),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            left: 0));
        children.add(Positioned(
            child: _DropAnchorWidget(
                model: model,
                item: item,
                tabs: tabs,
                position: DropPosition.right),
            width: horizontalEdgeWidth,
            bottom: 0,
            top: 0,
            right: 0));
      }
      if (availableCenterHeight >= _minimalSize) {
        children.add(Positioned(
            child: _DropAnchorWidget(
                model: model,
                item: item,
                tabs: tabs,
                position: DropPosition.top),
            height: verticalEdgeHeight,
            top: 0,
            left: 0,
            right: 0));
        children.add(Positioned(
            child: _DropAnchorWidget(
                model: model,
                item: item,
                tabs: tabs,
                position: DropPosition.bottom),
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
      {required this.model, this.item, this.tabs, required this.position});

  final DockingModel model;
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
          if (item != null) {
            model.layout.move(
                draggedItem: data, targetArea: item!, dropPosition: position);
          } else if (tabs != null) {
            model.layout.move(
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
