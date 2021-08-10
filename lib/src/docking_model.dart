import 'package:docking/src/layout/docking_layout.dart';
import 'package:flutter/cupertino.dart';

/// The [Docking] model.
class DockingModel extends ChangeNotifier {
  DockingModel({required DockingLayout layout}) : this._layout = layout;

  final DockingLayout _layout;
  bool _dragging = false;

  bool get dragging => _dragging;

  set dragging(bool value) {
    _dragging = value;
    notifyListeners();
  }

  /// Gets the [DockingLayout].
  DockingLayout get layout => _layout;
}
