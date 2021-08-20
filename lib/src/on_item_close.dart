import 'package:docking/src/layout/docking_layout.dart';

/// Event that will be triggered after a [DockingItem] close.
typedef OnItemClose = void Function(DockingItem item);

/// Intercepts a [DockingItem] close event to indicates whether it can be closed.
typedef ItemCloseInterceptor = bool Function(DockingItem item);
