import 'package:docking/docking.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(DockingExampleApp());
}

class DockingExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Docking example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DockingExamplePage(),
    );
  }
}

class DockingExamplePage extends StatefulWidget {
  @override
  _DockingExamplePageState createState() => _DockingExamplePageState();
}

class _DockingExamplePageState extends State<DockingExamplePage> {
  late DockingLayout layout;

  @override
  void initState() {
    super.initState();

    int v = 1;
    layout = DockingLayout(
        root: DockingRow([
      _build(v++),
      DockingColumn([
        DockingRow([_build(v++), _build(v++, closable: false)]),
        DockingTabs([_build(v++), _build(v++), _build(v++)]),
        _build(v++)
      ])
    ]));
  }

  DockingItem _build(int value, {bool closable = true}) {
    return DockingItem(
        name: value.toString(),
        closable: closable,
        widget: Container(child: Center(child: Text('Child $value'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabbedViewTheme(data: TabbedViewThemeData.classic(), child: Container(
            child: Docking(layout: layout, maximizableItem: true, maximizableTabs: true), padding: EdgeInsets.all(16))));
  }
}
