import 'package:docking/src/docking_buttons_builder.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/on_item_close.dart';
import 'package:docking/src/on_item_selection.dart';

class DockingProvider {
  const DockingProvider(
      {required this.layout,
      required this.onItemSelection,
      required this.onItemClose,
      required this.itemCloseInterceptor,
      required this.dockingButtonsBuilder,
      required this.maximizableItem,
      required this.maximizableTab,
      required this.maximizableTabsArea,
      required this.antiAliasingWorkaround});

  final DockingLayout? layout;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;
  final DockingButtonsBuilder? dockingButtonsBuilder;
  final bool maximizableItem;
  final bool maximizableTab;
  final bool maximizableTabsArea;
  final bool antiAliasingWorkaround;
}
