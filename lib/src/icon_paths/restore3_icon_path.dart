import 'dart:ui';

import 'package:tabbed_view/tabbed_view.dart';

/// Restore icon 3
class Restore3IconPath extends IconPath {
  const Restore3IconPath();

  @override
  Path build(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.3000000);
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.7000000, size.height);
    path.close();
    return path;
  }
}
