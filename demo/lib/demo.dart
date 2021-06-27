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
  Widget _build(int value) {
    return Container(child: Center(child: Text('Child $value')));
  }

  @override
  Widget build(BuildContext context) {
    Docking docking = _buildRC();

    return Scaffold(
        body: Container(
            child: Center(
                child: SizedBox(child: docking, width: 500, height: 400)),
            padding: EdgeInsets.all(16)));
  }

  Docking _buildR() {
    int v = 1;
    Widget child1 = _build(v++);
    Widget child2 = _build(v++);
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
    return docking;
  }

  Docking _buildC() {
    int v = 1;
    Widget child1 = _build(v++);
    Widget child2 = _build(v++);
    DockingLayout layout = DockingLayout(
        root: DockingColumn([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
    return docking;
  }

  Docking _buildT() {
    int v = 1;
    Widget child1 = _build(v++);
    Widget child2 = _build(v++);
    DockingLayout layout = DockingLayout(
        root: DockingTabs([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
    return docking;
  }

  Docking _buildRCT() {
    int v = 1;
    Widget child1 = _build(v++);
    Widget child2 = _build(v++);
    Widget child3 = _build(v++);
    Widget child4 = _build(v++);
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
    return docking;
  }

  Docking _buildRC() {
    int v = 1;
    Widget child1 = _build(v++);
    Widget child2 = _build(v++);
    Widget child3 = _build(v++);
    DockingLayout layout = DockingLayout(
        root: DockingRow([
          DockingItem(name: '1', widget: child1),
          DockingColumn([
            DockingItem(name: '2', widget: child2),
            DockingItem(name: '3', widget: child3)
          ])
        ]));
    Docking docking = Docking(layout: layout);
    return docking;
  }
}
