import 'package:docking/docking.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(child: _buildDocking(), padding: EdgeInsets.all(16)));
  }

  Widget _buildDocking() {
    int v = 1;
    DockingLayout layout = DockingLayout(DockingRow([
      _build(v++),
      _build(v++),
      DockingColumn([
        DockingRow([
          _build(v++),
          DockingColumn([_build(v++), _build(v++)])
        ]),
        DockingTabs([_build(v++), _build(v++), _build(v++)]),
        _build(v++)
      ])
    ]));

    return Docking(layout: layout);
  }

  DockingItem _build(int value) {
    return DockingItem(
        name: value.toString(),
        widget: Container(child: Center(child: Text('Child $value'))));
  }
}
