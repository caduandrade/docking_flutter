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
  late DockingLayout _layout;

  @override
  void initState() {
    super.initState();

    int v = 1;
    _layout = DockingLayout(
        root: DockingRow([
      _build(v++),
      DockingColumn([
        DockingRow(
            [_build(99, maximizable: false), DockingItem(name: 'non-closable', closable: false, widget: CenterText(text: 'non-closable'))]),
        DockingTabs([_build(v++), _build(v++), _build(v++)]),
        _build(v++)
      ])
    ]));
  }

  DockingItem _build(int value, {bool closable = true, bool? maximizable}) {
    return DockingItem(
      weight: (value!=99)?null:0.2,
        name: value.toString(),
        closable: closable,
        maximizable: maximizable,
        widget: Container(child: Center(child: Text('Child $value'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabbedViewTheme(
            data: TabbedViewThemeData.classic(),
            child: Container(
                child: Docking(layout: _layout), padding: EdgeInsets.all(16))));
  }
}

class CenterText extends StatelessWidget{

  const CenterText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
