import 'package:docking/src/docking_icons.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// The [Docking] theme.
/// Defines the configuration of the overall visual [Theme] for a widget subtree within the app.
class DockingThemeData {
  DockingThemeData({IconProvider? restoreIcon, IconProvider? maximizeIcon})
      : this.restoreIcon = restoreIcon != null
            ? restoreIcon
            : IconProvider.path(DockingIcons.restore),
        this.maximizeIcon = maximizeIcon != null
            ? maximizeIcon
            : IconProvider.data(Icons.web_asset_sharp);

  /// Icon for the restore button.
  IconProvider restoreIcon;

  /// Icon for the maximize button.
  IconProvider maximizeIcon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DockingThemeData &&
          runtimeType == other.runtimeType &&
          restoreIcon == other.restoreIcon &&
          maximizeIcon == other.maximizeIcon;

  @override
  int get hashCode => restoreIcon.hashCode ^ maximizeIcon.hashCode;
}
