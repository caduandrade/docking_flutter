import 'package:flutter/widgets.dart';

class DockingLayoutItem {}

class DockingWidget extends DockingLayoutItem {
  DockingWidget({this.name, required this.widget});

  final String? name;
  final Widget widget;
}

class DockingRow extends DockingLayoutItem {
  DockingRow(this.children);

  final List<DockingLayoutItem> children;
}

class DockingColumn extends DockingLayoutItem {
  DockingColumn(this.children);

  final List<DockingLayoutItem> children;
}

class DockingTabs extends DockingLayoutItem {
  DockingTabs(this.children);

  final List<DockingWidget> children;
}

class DockingLayout {
  DockingLayout(this.root);

  final DockingLayoutItem root;
}
