import 'package:docking/docking.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DockingDemoApp());
}

class DockingDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Docking demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DockingDemoPage(),
    );
  }
}

class DockingDemoPage extends StatefulWidget {
  @override
  _DockingDemoPageState createState() => _DockingDemoPageState();
}

class _DockingDemoPageState extends State<DockingDemoPage> {
  DockingItem _build(int value) {
    return DockingItem(
        name: value.toString(),
        widget: Container(child: Center(child: Text('Child $value'))));
  }

  Widget _build2(int value) {
    return Container(child: Center(child: Text('Child $value')));
  }

  @override
  Widget build(BuildContext context) {
    int v = 1;
    Widget child1 = _build2(v++);
    Widget child2 = _build2(v++);
    Widget child3 = _build2(v++);
    Widget child4 = _build2(v++);
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingColumn([
        DockingItem(name: '2', widget: child2),
        DockingTabs([
          DockingItem(name: '3', widget: child3),
          DockingItem(name: '4', widget: child4)
        ])
      ])
    ]));
    Docking docking = Docking(layout: layout);
    return Scaffold(
        body: Container(child: docking, padding: EdgeInsets.all(16)));
  }
}
