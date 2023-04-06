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

  late DockingItem _itemToRemove;
  late DockingItem _dropArea;

  @override
  void initState() {
    super.initState();
    int v = 1;

    _itemToRemove = _buildItem('remove');
    _dropArea = _buildItem('dropArea');
    _layout = DockingLayout(
        root: DockingRow([_buildItem('item'), _itemToRemove, _dropArea]));
  }

  DockingItem _buildItem(String value) {
    return DockingItem(name: value, widget: Center(child: Text('$value')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabbedViewTheme(
            data: TabbedViewThemeData.classic(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(onPressed: _remove, child: Text('remove')),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed: _add, child: Text('add')),
                  Expanded(
                      child: Container(
                          child: Docking(layout: _layout),
                          padding: EdgeInsets.all(16)))
                ])));
  }

  void _remove() {
    if (!_itemToRemove.disposed) {
      _layout.removeItem(item: _itemToRemove);
    }
  }

  void _add() {
    _layout.addItemOn(
        newItem: _buildItem('newItem'),
        targetArea: _dropArea,
        dropPosition: DropPosition.bottom);
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
