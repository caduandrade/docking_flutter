import 'package:docking/src/layout/docking_layout.dart';

abstract class AreaBuilder {
  const AreaBuilder();

  /// Builds a [DockingItem].
  DockingItem buildDockingItem(
      {required dynamic id, required double? weight, required bool maximized});

  /// Builds a [DockingRow].
  DockingRow buildDockingRow(
      {required dynamic id,
      required double? weight,
      required List<DockingArea> children});

  /// Builds a [DockingColumn].
  DockingColumn buildDockingColumn(
      {required dynamic id,
      required double? weight,
      required List<DockingArea> children});

  /// Builds a [DockingTabs].
  DockingTabs buildDockingTabs(
      {required dynamic id,
      required double? weight,
      required bool maximized,
      required List<DockingItem> children});
}

mixin AreaBuilderMixin implements AreaBuilder {
  DockingRow buildDockingRow(
      {required dynamic id,
      required double? weight,
      required List<DockingArea> children}) {
    return DockingRow(children, id: id, weight: weight);
  }

  DockingColumn buildDockingColumn(
      {required dynamic id,
      required double? weight,
      required List<DockingArea> children}) {
    return DockingColumn(children, id: id, weight: weight);
  }

  /// Builds a [DockingTabs].
  DockingTabs buildDockingTabs(
      {required dynamic id,
      required double? weight,
      required bool maximized,
      required List<DockingItem> children}) {
    return DockingTabs(children, id: id, weight: weight, maximized: maximized);
  }
}
