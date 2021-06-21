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
    DockingLayout layout = DockingLayout(DockingRow([
      _build(1),
      DockingColumn([
        _build(2),
        DockingTabs([_build(3), _build(4), _build(5)]),
        _build(6)
      ])
    ]));

    return Docking(layout: layout);
  }

  DockingWidget _build(int value) {
    return DockingWidget(
        name: value.toString(),
        widget: Container(child: Center(child: Text('Child $value'))));
  }
}
