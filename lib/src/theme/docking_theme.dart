import 'package:docking/src/theme/docking_theme_data.dart';
import 'package:flutter/widgets.dart';

/// Applies a [Docking] theme to descendant widgets.
/// See also:
///
///  * [DockingThemeData], which describes the actual configuration of a theme.
class DockingTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const DockingTheme({
    Key? key,
    required this.child,
    required this.data,
  }) : super(key: key);

  /// Specifies the theme for descendant widgets.
  final DockingThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  static final DockingThemeData _defaultTheme = DockingThemeData();

  /// The data from the closest [DockingTheme] instance that encloses the given
  /// context.
  static DockingThemeData of(BuildContext context) {
    final _InheritedTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    final DockingThemeData data = inheritedTheme?.data ?? _defaultTheme;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(data: data, child: child);
  }
}

class _InheritedTheme extends InheritedWidget {
  const _InheritedTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final DockingThemeData data;

  @override
  bool updateShouldNotify(_InheritedTheme old) => data != old.data;
}
