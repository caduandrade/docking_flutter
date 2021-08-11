import 'package:demoflu/demoflu.dart';
import 'package:flutter/material.dart';

import 'layout_c.dart';
import 'layout_r.dart';
import 'layout_rc.dart';
import 'layout_rcr.dart';
import 'layout_rct.dart';
import 'layout_t.dart';

void main() {
  bool dev = true;

  Size? maxSize;
  bool resizable = false;
  if (dev) {
    maxSize = Size(500, 400);
    resizable = true;
  }
  runApp(DemoFluApp(
    title: 'Docking (0.3.0)',
    widgetBackground: Colors.white,
    maxSize: maxSize,
    resizable: resizable,
    sections: [
      Section(name: 'Layouts', examples: [
        Example(name: 'Row', builder: (buttonClickNotifier) => LayoutR()),
        Example(name: 'Column', builder: (buttonClickNotifier) => LayoutC()),
        Example(name: 'Tabs', builder: (buttonClickNotifier) => LayoutT()),
        Example(
            name: 'Row > Column', builder: (buttonClickNotifier) => LayoutRC()),
        Example(
            name: 'Row > Column > Tabs',
            builder: (buttonClickNotifier) => LayoutRCT()),
        Example(
            name: 'Row > Column > Row',
            builder: (buttonClickNotifier) => LayoutRCR())
      ])
    ],
  ));
}
