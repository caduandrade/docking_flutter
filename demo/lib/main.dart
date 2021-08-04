import 'package:demo/layout_c.dart';
import 'package:demo/layout_r.dart';
import 'package:demo/layout_rc.dart';
import 'package:demo/layout_rcr.dart';
import 'package:demo/layout_rct.dart';
import 'package:demo/layout_t.dart';
import 'package:demoflu/demoflu.dart';
import 'package:flutter/material.dart';

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
