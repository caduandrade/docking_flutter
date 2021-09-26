import 'dart:ui';

/// Docking icons
class DockingIcons {
  DockingIcons._();

  static Path restore(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.3000000, size.height * 0.2500000);
    path.lineTo(size.width * 0.3000000, size.height * 0.7500000);
    path.lineTo(size.width * 0.8000000, size.height * 0.7500000);
    path.close();
    return path;
  }
}
