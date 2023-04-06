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
      _buildItem(v++, weight: .2),
      DockingColumn([
        DockingRow([_nonMaximizableItem, _nonClosableItem, _minimalSizeItem]),
        DockingTabs([_buildItem(v++), _buildItem(v++)]),
        _minimalWeightItem
      ])
    ]));
  }

  DockingItem get _minimalWeightItem => DockingItem(
      name: 'minimalSize',
      minimalWeight: .15,
      widget: CenterText(text: 'minimalWeight: .15'));

  DockingItem get _minimalSizeItem => DockingItem(
      name: 'minimalSize',
      minimalSize: 150,
      widget: CenterText(text: 'minimalSize: 150'));

  DockingItem get _nonMaximizableItem => DockingItem(
      name: 'non-maximizable',
      maximizable: false,
      widget: CenterText(text: 'non-maximizable'));

  DockingItem get _nonClosableItem => DockingItem(
      name: 'non-closable',
      closable: false,
      widget: CenterText(text: 'non-closable'));

  DockingItem _buildItem(int value,
      {double? weight, bool closable = true, bool? maximizable}) {
    return DockingItem(
        weight: weight,
        name: value.toString(),
        closable: closable,
        maximizable: maximizable,
        widget: Container(child: Center(child: Text('$value'))));
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

class CenterText extends StatelessWidget {
  const CenterText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, overflow: TextOverflow.ellipsis));
  }
}
