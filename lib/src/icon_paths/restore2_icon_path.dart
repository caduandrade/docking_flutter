import 'dart:ui';

import 'package:tabbed_view/tabbed_view.dart';

/// Restore icon 2
class Restore2IconPath extends IconPath {
  const Restore2IconPath();

  @override
  Path build(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.4250000, 0);
    path.lineTo(size.width * 0.4250000, size.height * 0.4250000);
    path.lineTo(0, size.height * 0.4250000);
    path.close();
    path.moveTo(size.width * 0.5750000, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.4250000);
    path.lineTo(size.width * 0.5750000, size.height * 0.4250000);
    path.close();
    path.moveTo(0, size.height * 0.5750000);
    path.lineTo(size.width * 0.4250000, size.height * 0.5750000);
    path.lineTo(size.width * 0.4250000, size.height);
    path.lineTo(0, size.height);
    path.close();
    path.moveTo(size.width * 0.6000000, size.height * 0.5750000);
    path.lineTo(size.width, size.height * 0.5750000);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.5750000, size.height);
    path.close();
    return path;
  }
}
