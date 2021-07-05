import 'package:demo/layout_c.dart';
import 'package:demo/layout_r.dart';
import 'package:demo/layout_rc.dart';
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
      DFSection(name: 'Layouts', examples: [
        DFExample(name: 'Row', builder: (BuildContext context) => LayoutR()),
        DFExample(name: 'Column', builder: (BuildContext context) => LayoutC()),
        DFExample(name: 'Tabs', builder: (BuildContext context) => LayoutT()),
        DFExample(
            name: 'Row > Column',
            builder: (BuildContext context) => LayoutRC()),
        DFExample(
            name: 'Row > Column > Tabs',
            builder: (BuildContext context) => LayoutRCT())
      ])
    ],
  ));
}
