import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';

/// Buttons builder for [DockingItem] and [DockingTabs].
typedef DockingButtonsBuilder = List<TabButton> Function(
    BuildContext context, DockingTabs? dockingTabs, DockingItem? dockingItem);
