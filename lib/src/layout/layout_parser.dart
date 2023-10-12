import 'package:docking/src/layout/docking_layout.dart';
import 'package:flutter/widgets.dart';

/// Parser from DockingLayout to String.
abstract class LayoutParser {
  late String _layout;

  /// Converts ID to String.
  String idToString(dynamic id);

  /// Converts String to ID.
  dynamic stringToId(String id);

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

  /// Converts a layout into a String to be stored.
  ///
  /// The String will have the following structure:
  /// VERSION:AREAS_LENGTH:AREAS
  ///
  /// The VERSION group has a fixed value: V1
  ///
  /// The AREAS group separates each area with a comma and follows the
  /// pattern: AREA_INDEX_1(AREA_CONFIGURATION),...,AREA_INDEX_N(AREA_CONFIGURATION)
  /// Example: 1(AREA_CONFIGURATION),2(AREA_CONFIGURATION),3(AREA_CONFIGURATION)
  ///
  /// The AREA_CONFIGURATION group represents all area data given the class:
  ///
  /// * [DockingItem]
  ///   * AREA_ACRONYM
  ///   * ID_LENGTH
  ///   * ID
  ///   * WEIGHT
  ///   * MAXIMIZED
  /// * [DockingColumn]
  ///   * AREA_ACRONYM
  ///   * ID_LENGTH
  ///   * ID
  ///   * WEIGHT
  ///   * CHILDREN_INDEXES
  /// * [DockingRow]
  ///   * AREA_ACRONYM
  ///   * ID_LENGTH
  ///   * ID
  ///   * WEIGHT
  ///   * CHILDREN_INDEXES
  /// * [DockingTabs]
  ///   * AREA_ACRONYM
  ///   * ID_LENGTH
  ///   * ID
  ///   * WEIGHT
  ///   * MAXIMIZED
  ///   * CHILDREN_INDEXES
  ///
  /// Example:
  /// V1:3:1(R;0;;;2,3),2(I;6;my_id1;0.5;F),3(I;6;my_id2;0.5;F)
  String stringify({required DockingLayout layout}) {
    final List<DockingArea> areas = layout.layoutAreas();

    String str = 'V1:${areas.length}:';
    for (int i = 0; i < areas.length; i++) {
      if (i > 0) {
        str += ',';
      }
      final DockingArea area = areas[i];
      str += '${area.index}(';
      str += '${area.areaAcronym};';
      str += '${stringifyArea(area: area)}';

      if (area is DockingItem) {
        str += ';';
        str += stringifyItem(item: area);
      } else if (area is DockingTabs) {
        str += ';';
        str += stringifyTabs(tabs: area);
      }

      if (area is DockingParentArea) {
        str += ';';
        str += stringifyParent(parent: area);
      }
      str += ')';
    }

    return str;
  }

  /// Converts the [DockingArea] configuration into a String with the
  /// following data separated by semicolons:
  /// * ID_LENGTH
  /// * ID
  /// * WEIGHT
  ///
  /// Example: 3;id1;.2
  @visibleForTesting
  String stringifyArea({required DockingArea area}) {
    List<String> data = [];
    // ID_LENGTH and ID
    final String id = idToString(area.id);
    data.add(id.length.toString());
    data.add(id);
    // WEIGHT
    final String weight = area.weight != null ? area.weight.toString() : '';
    data.add(weight);

    return data.join(';');
  }

  /// Converts the [DockingItem] configuration into a String with the
  /// following data:
  /// * MAXIMIZED
  ///
  /// [T] is [TRUE] and [F] is [FALSE].
  ///
  /// Example:
  /// F
  @visibleForTesting
  String stringifyItem({required DockingItem item}) {
    return item.maximized ? 'T' : 'F';
  }

  /// Converts the [DockingTabs] configuration into a String with the
  /// following data:
  /// * MAXIMIZED
  ///
  /// Example:
  /// T
  @visibleForTesting
  String stringifyTabs({required DockingTabs tabs}) {
    return tabs.maximized ? 'T' : 'F';
  }

  /// Converts the children indexes to String separated by colon.
  ///
  /// Example:
  /// 4,5,6
  @visibleForTesting
  String stringifyParent({required DockingParentArea parent}) {
    List<String> indexes = [];
    for (int i = 0; i < parent.childrenCount; i++) {
      final DockingArea child = parent.childAt(i);
      if (child.index == -1) {
        throw StateError('Child does not belong to any layout.');
      }
      indexes.add(child.index.toString());
    }
    return indexes.join(',');
  }

  /// Builds a [DockingLayout] from formatted layout String.
  DockingLayout layoutFrom(String layout) {
    if (layout.startsWith('V1:')) {
      _layout = layout.substring(3);

      final int areasLength = _removeFirstRequiredInt(
          stop: ':',
          errorMessage: 'The number of areas could not be identified.');

      Map<int, _AreaConfig> areas = {};

      for (int areaIndex = 1; areaIndex <= areasLength; areaIndex++) {
        final int indexFromLayout = _removeFirstRequiredInt(
            stop: '(',
            errorMessage: 'The area index could not be identified: $areaIndex');
        if (areaIndex != indexFromLayout) {
          throw StateError('Unexpected index: $indexFromLayout');
        }
        final String acronym = _removeFirstToken(
            stop: ';',
            errorMessage: 'The area acronym could not be identified.');

        final int idLength = _removeFirstRequiredInt(
            stop: ';',
            errorMessage:
                'Error reading area $areaIndex. Not found: id length.');
        final String id = _removeToken(
            length: idLength,
            errorMessage: 'Error reading area $areaIndex. Not found: id.');

        final double? weight = _removeFirstOptionalDouble(
            stop: ';', errorMessage: 'Invalid weight.');

        if (acronym == 'I') {
          final bool maximized = _removeFirstRequiredBool(
              stop: ')',
              errorMessage:
                  'Error reading area $areaIndex. Not found: maximized.');
          areas[areaIndex] =
              _ItemConfig(id: id, weight: weight, maximized: maximized);
        } else if (acronym == 'R') {
          List<int> childrenIndexes = _removeChildrenIndexes();
          areas[areaIndex] = _RowConfig(
              id: id, weight: weight, childrenIndexes: childrenIndexes);
        } else if (acronym == 'C') {
          List<int> childrenIndexes = _removeChildrenIndexes();
          areas[areaIndex] = _ColumnConfig(
              id: id, weight: weight, childrenIndexes: childrenIndexes);
        } else if (acronym == 'T') {
          final bool maximized = _removeFirstRequiredBool(
              stop: ';', errorMessage: 'Unrecognized syntax.');
          List<int> childrenIndexes = _removeChildrenIndexes();
          areas[areaIndex] = _TabsConfig(
              id: id,
              weight: weight,
              maximized: maximized,
              childrenIndexes: childrenIndexes);
        } else {
          throw StateError('Invalid area acronym: $acronym');
        }

        if (areaIndex < areasLength) {
          if (_removeNext() != ',') {
            throw StateError('Unrecognized syntax. Area separator not found.');
          }
        }
      }

      if (_layout.isNotEmpty) {
        throw StateError('Unrecognized syntax: $_layout');
      }

      if (areasLength == 0) {
        return DockingLayout();
      }
      final _AreaConfig rootConfig = areas.getArea(1);
      final DockingArea root = _buildRoot(parent: rootConfig, areas: areas);
      return DockingLayout(root: root);
    } else {
      if (layout.startsWith('V')) {
        throw StateError('Unsupported layout version.');
      }
      throw StateError('Unable to identify layout version.');
    }
  }

  DockingArea _buildRoot(
      {required _AreaConfig parent, required Map<int, _AreaConfig> areas}) {
    if (parent is _ItemConfig) {
      return buildDockingItem(
          id: parent.id, weight: parent.weight, maximized: parent.maximized);
    } else if (parent is _ParentConfig) {
      List<DockingArea> children = [];
      parent.childrenIndexes.forEach((childIndex) {
        final _AreaConfig childConfig = areas.getArea(childIndex);
        children.add(_buildRoot(parent: childConfig, areas: areas));
      });
      if (parent is _RowConfig) {
        return buildDockingRow(
            id: parent.id, weight: parent.weight, children: children);
      } else if (parent is _ColumnConfig) {
        return buildDockingColumn(
            id: parent.id, weight: parent.weight, children: children);
      }
      if (parent is _TabsConfig) {
        List<DockingItem> items = [];
        for (DockingArea area in children) {
          items.add(area as DockingItem);
        }
        return buildDockingTabs(
            id: parent.id,
            weight: parent.weight,
            maximized: parent.maximized,
            children: items);
      }
    }
    throw StateError('Unrecognized type: ${parent.runtimeType}');
  }

  String _removeNext() {
    if (_layout.isEmpty) {
      throw new StateError('Insufficient characters.');
    }
    final String next = _layout.substring(0, 1);
    _layout = _layout.substring(1);
    return next;
  }

  List<int> _removeChildrenIndexes() {
    final String token =
        _removeFirstToken(stop: ')', errorMessage: 'Invalid children indexes.');
    if (token.isEmpty) {
      throw StateError('Parent without child.');
    }
    List<int> indexes = [];
    token.split(',').forEach((str) {
      int? index = int.tryParse(str);
      if (index == null) {
        throw StateError('Invalid index: $str');
      }
      indexes.add(index);
    });
    return indexes;
  }

  bool _removeFirstRequiredBool(
      {required String stop, required String errorMessage}) {
    final String token =
        _removeFirstToken(stop: stop, errorMessage: errorMessage);
    if (token == 'T') {
      return true;
    }
    if (token == 'F') {
      return false;
    }
    throw StateError(errorMessage);
  }

  double? _removeFirstOptionalDouble(
      {required String stop, required String errorMessage}) {
    final String token =
        _removeFirstToken(stop: stop, errorMessage: errorMessage);
    if (token.isEmpty) {
      return null;
    }
    final double? number = double.tryParse(token);
    if (number == null) {
      throw StateError(errorMessage);
    }
    return number;
  }

  int _removeFirstRequiredInt(
      {required String stop, required String errorMessage}) {
    final String token =
        _removeFirstToken(stop: stop, errorMessage: errorMessage);
    final int? number = int.tryParse(token);
    if (number == null) {
      throw StateError(errorMessage);
    }
    return number;
  }

  String _removeFirstToken(
      {required String stop, required String errorMessage}) {
    final int index = _layout.indexOf(stop);
    if (index == -1) {
      throw StateError(errorMessage);
    }
    final String token = _layout.substring(0, index);
    _layout = _layout.substring(index + 1);
    return token;
  }

  String _removeToken({required int length, required String errorMessage}) {
    if (_layout.length < length) {
      throw StateError(errorMessage);
    }
    final String token = _layout.substring(0, length);
    _layout = _layout.substring(length + 1);
    return token;
  }
}

mixin LayoutParserIdMixin {
  /// Default conversion from ID to String.
  String idToString(dynamic id) {
    return id == null ? '' : id.toString();
  }

  /// Default conversion from String to ID.
  dynamic stringToId(String id) {
    return id == '' ? null : id;
  }
}

mixin LayoutParserBuildsMixin {
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

class _AreaConfig {
  _AreaConfig({required this.id, required this.weight});

  final String id;
  final double? weight;
}

class _ParentConfig extends _AreaConfig {
  _ParentConfig(
      {required String id,
      required double? weight,
      required List<int> childrenIndexes})
      : childrenIndexes = List.unmodifiable(childrenIndexes),
        super(id: id, weight: weight);

  final List<int> childrenIndexes;
}

class _RowConfig extends _ParentConfig {
  _RowConfig(
      {required String id,
      required double? weight,
      required List<int> childrenIndexes})
      : super(id: id, weight: weight, childrenIndexes: childrenIndexes);
}

class _ColumnConfig extends _ParentConfig {
  _ColumnConfig(
      {required String id,
      required double? weight,
      required List<int> childrenIndexes})
      : super(id: id, weight: weight, childrenIndexes: childrenIndexes);
}

class _TabsConfig extends _ParentConfig {
  _TabsConfig(
      {required String id,
      required double? weight,
      required this.maximized,
      required List<int> childrenIndexes})
      : super(id: id, weight: weight, childrenIndexes: childrenIndexes);

  final bool maximized;
}

class _ItemConfig extends _AreaConfig {
  final bool maximized;

  _ItemConfig(
      {required String id, required double? weight, required this.maximized})
      : super(id: id, weight: weight);
}

extension E on Map<int, _AreaConfig> {
  _AreaConfig getArea(int index) {
    _AreaConfig? config = this[index];
    if (config == null) {
      throw StateError('Area index not found: $index');
    }
    return config;
  }
}
