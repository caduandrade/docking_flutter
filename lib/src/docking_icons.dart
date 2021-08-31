import 'dart:ui';

/// Docking icons
class DockingIcons {
  DockingIcons._();

  static Path maximize(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.1500000, size.height * 0.1500000);
    path.lineTo(size.width * 0.1500000, size.height * 0.8500000);
    path.lineTo(size.width * 0.8500000, size.height * 0.8500000);
    path.lineTo(size.width * 0.8500000, size.height * 0.1500000);
    path.close();
    path.moveTo(size.width * 0.2500000, size.height * 0.4000000);
    path.lineTo(size.width * 0.7500000, size.height * 0.4000000);
    path.lineTo(size.width * 0.7500000, size.height * 0.7500000);
    path.lineTo(size.width * 0.2500000, size.height * 0.7500000);
    path.close();
    return path;
  }

  static Path restore(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.3000000, size.height * 0.2500000);
    path.lineTo(size.width * 0.3000000, size.height * 0.7500000);
    path.lineTo(size.width * 0.8000000, size.height * 0.7500000);
    path.close();
    return path;
  }
}
