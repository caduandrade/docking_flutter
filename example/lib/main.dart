import 'package:docking/docking.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(const DockingExampleApp());
}

class DockingExampleApp extends StatelessWidget {
  const DockingExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Docking example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DockingExamplePage(),
    );
  }
}

class DockingExamplePage extends StatefulWidget {
  const DockingExamplePage({Key? key}) : super(key: key);

  @override
  DockingExamplePageState createState() => DockingExamplePageState();
}

class DockingExamplePageState extends State<DockingExamplePage> {
  late DockingLayout _layout;

  @override
  void initState() {
    super.initState();
    _layout = DockingLayout(
      root: DockingRow([
        DockingTabs([
          DockingItem(
            id: 'left_1',
            name: 'Home',
            widget: const CenterText(text: 'Left — Home'),
          ),
          DockingItem(
            id: 'left_2',
            name: 'Documents',
            widget: const CenterText(text: 'Left — Documents'),
          ),
          DockingItem(
            id: 'left_3',
            name: 'Downloads',
            widget: const CenterText(text: 'Left — Downloads'),
          ),
          DockingItem(
            id: 'left_4',
            name: 'Desktop',
            widget: const CenterText(text: 'Left — Desktop'),
          ),
        ]),
        DockingTabs([
          DockingItem(
            id: 'right_1',
            name: 'Android',
            widget: const CenterText(text: 'Right — Android'),
          ),
          DockingItem(
            id: 'right_2',
            name: 'DCIM',
            widget: const CenterText(text: 'Right — DCIM'),
          ),
          DockingItem(
            id: 'right_3',
            name: 'Pictures',
            widget: const CenterText(text: 'Right — Pictures'),
          ),
          DockingItem(
            id: 'right_4',
            name: 'Music',
            widget: const CenterText(text: 'Right — Music'),
          ),
        ]),
      ]),
    );
  }

  bool _onCloseInterceptor(DockingItem item) {
    // Block close if this is the very last tab in the entire layout
    final totalItems = _layout.layoutAreas().whereType<DockingItem>().length;
    return totalItems > 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabbedViewTheme(
        data: TabbedViewThemeData.minimalist(),
        child: Docking(
          layout: _layout,
          draggable: true,
          itemCloseInterceptor: _onCloseInterceptor,
          dockingButtonsBuilder: (context, dockingTabs, dockingItem) {
            if (dockingTabs != null) {
              return [
                TabButton(
                  icon: IconProvider.data(Icons.add),
                  onPressed: () {
                    _layout.addItemOn(
                      newItem: DockingItem(
                        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                        name: 'New Tab',
                        widget: const CenterText(text: 'New Tab'),
                      ),
                      targetArea: dockingTabs,
                      dropIndex: dockingTabs.childrenCount,
                    );
                  },
                )
              ];
            }
            if (dockingItem != null) {
              return [
                TabButton(
                  icon: IconProvider.data(Icons.add),
                  onPressed: () {
                    _layout.addItemOn(
                      newItem: DockingItem(
                        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                        name: 'New Tab',
                        widget: const CenterText(text: 'New Tab'),
                      ),
                      targetArea: dockingItem,
                      dropIndex: 1,
                    );
                  },
                )
              ];
            }
            return [];
          },
        ),
      ),
    );
  }
}

class CenterText extends StatelessWidget {
  const CenterText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}
