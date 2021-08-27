import 'dart:ui';

import 'package:tabbed_view/tabbed_view.dart';

/// Maximize icon 2
class Maximize2IconPath extends IconPath {
  const Maximize2IconPath();

  @override
  Path build(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    path.moveTo(size.width * 0.1500000, size.height * 0.1500000);
    path.lineTo(size.width * 0.8500000, size.height * 0.1500000);
    path.lineTo(size.width * 0.8500000, size.height * 0.3500000);
    path.lineTo(size.width * 0.1500000, size.height * 0.3500000);
    path.close();
    return path;
  }
}
