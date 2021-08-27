import 'package:docking/src/icon_paths/maximize2_icon_path.dart';
import 'package:docking/src/icon_paths/maximize_icon_path.dart';
import 'package:docking/src/icon_paths/restore2_icon_path.dart';
import 'package:docking/src/icon_paths/restore_icon_path.dart';
import 'package:docking/src/icon_paths/restore3_icon_path.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Docking icons
class DockingIcons {
  DockingIcons._();

  static const IconPath maximize = MaximizeIconPath();
  static const IconPath maximize2 = Maximize2IconPath();
  static const IconPath restore = RestoreIconPath();
  static const IconPath restore2 = Restore2IconPath();
  static const IconPath restore3 = Restore3IconPath();
}
