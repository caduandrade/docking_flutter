import 'dart:ui';

import 'package:tabbed_view/tabbed_view.dart';

/// Maximize icon
class MaximizeIconPath extends IconPath {
  const MaximizeIconPath();

  @override
  Path build(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    path.moveTo(size.width * 0.1250000, size.height * 0.3500000);
    path.lineTo(size.width * 0.8750000, size.height * 0.3500000);
    path.lineTo(size.width * 0.8750000, size.height * 0.8750000);
    path.lineTo(size.width * 0.1250000, size.height * 0.8750000);
    path.close();
    return path;
  }
}
