import 'package:flutter/cupertino.dart';

class DockingDrag extends ChangeNotifier {
  bool _enable = false;

  bool get enable => _enable;

  set enable(bool value) {
    _enable = value;
    notifyListeners();
  }
}
