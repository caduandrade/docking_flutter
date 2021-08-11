import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';

import 'example_widget.dart';

class LayoutR extends ExampleStatelessWidget {
  @override
  Widget build(BuildContext context) {
    int v = 1;
    Widget child1 = buildChild(v++);
    Widget child2 = buildChild(v++);
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
    return docking;
  }
}
