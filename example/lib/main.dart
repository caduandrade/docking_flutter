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
      _build(1, true),
      DockingColumn([
        _build(2, true),
        DockingTabs([_build(3, false), _build(4, false), _build(5, false)]),
        _build(6, true)
      ])
    ]));

    return Docking(layout: layout);
  }

  DockingWidget _build(int value, bool decorate) {
    BoxDecoration? decoration;
    if (decorate) {
      decoration = BoxDecoration(border: Border.all());
    }
    return DockingWidget(
        name: value.toString(),
        widget: Container(
            child: Center(child: Text('Child $value')),
            decoration: decoration));
  }
}
