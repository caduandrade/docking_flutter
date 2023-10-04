import 'package:docking/src/layout/docking_layout.dart';
import 'package:flutter/widgets.dart';

/// Parser from DockingLayout to String.
abstract class LayoutParser {
  late String _layout;

  /// Converts ID to String.
  String idToString(dynamic id);

  /// Converts String to ID.
  dynamic stringToId(String id);

  /// Converts value to String.
  String valueToString(dynamic value);

  /// Converts String to value.
  dynamic stringToValue(String value);

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
  ///   * WEIGHT
  ///   * MINIMAL_WEIGHT
  ///   * MINIMAL_SIZE
  ///   * ID_LENGTH
  ///   * ID
  ///   * NAME_LENGTH
  ///   * NAME
  ///   * VALUE_LENGTH
  ///   * VALUE
  ///   * CLOSABLE
  ///   * MAXIMIZABLE
  ///   * MAXIMIZED
  ///   * CHILDREN_INDEXES
  /// * [DockingColumn]
  ///   * AREA_ACRONYM
  ///   * WEIGHT
  ///   * MINIMAL_WEIGHT
  ///   * MINIMAL_SIZE
  ///   * CHILDREN_INDEXES
  /// * [DockingRow]
  ///   * AREA_ACRONYM
  ///   * WEIGHT
  ///   * MINIMAL_WEIGHT
  ///   * MINIMAL_SIZE
  ///   * CHILDREN_INDEXES
  /// * [DockingTabs]
  ///   * AREA_ACRONYM
  ///   * WEIGHT
  ///   * MINIMAL_WEIGHT
  ///   * MINIMAL_SIZE
  ///   * MAXIMIZABLE
  ///   * MAXIMIZED
  ///   * CHILDREN_INDEXES
  ///
  /// Example:
  /// V1:1:1(1;I;.2;;100;5;my_id;7;my_name;8;my_value;T;;F)
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
  /// * WEIGHT
  /// * MINIMAL_WEIGHT
  /// * MINIMAL_SIZE
  ///
  /// Example: .2;;100
  @visibleForTesting
  String stringifyArea({required DockingArea area}) {
    List<String> data = [];
    // WEIGHT
    final String weight = area.weight != null ? area.weight.toString() : '';
    data.add(weight);
    // MINIMAL_SIZE
    final String minimalWeight =
        area.minimalWeight != null ? area.minimalWeight.toString() : '';
    data.add(minimalWeight);
    // MINIMAL_SIZE
    final String minimalSize =
        area.minimalSize != null ? area.minimalSize!.toStringAsFixed(0) : '';
    data.add(minimalSize);

    return data.join(';');
  }

  /// Converts the [DockingItem] configuration into a String with the
  /// following data separated by semicolons:
  /// * ID_LENGTH
  /// * ID
  /// * NAME_LENGTH
  /// * NAME
  /// * VALUE_LENGTH
  /// * VALUE
  /// * CLOSABLE
  /// * MAXIMIZABLE
  /// * MAXIMIZED
  ///
  /// [T] is [TRUE] and [F] is [FALSE].
  ///
  /// Example:
  /// 5;my_id;7;my_name;8;my_value;T;;F
  @visibleForTesting
  String stringifyItem({required DockingItem item}) {
    List<String> data = [];

    // ID_LENGTH and ID
    final String id = idToString(item.id);
    data.add(id.length.toString());
    data.add(id);

    // NAME_LENGTH and NAME
    final String name = item.name ?? '';
    data.add(name.length.toString());
    data.add(name);

    // VALUE_LENGTH and VALUE
    final String value = valueToString(item.value);
    data.add(value.length.toString());
    data.add(value);

    // CLOSABLE
    data.add(item.closable ? 'T' : 'F');

    // MAXIMIZABLE
    if (item.maximizable != null) {
      data.add(item.maximizable! ? 'T' : 'F');
    } else {
      data.add('');
    }

    // MAXIMIZED
    data.add(item.maximized ? 'T' : 'F');

    return data.join(';');
  }

  /// Converts the [DockingTabs] configuration into a String with the
  /// following data separated by semicolons:
  /// * MAXIMIZABLE
  /// * MAXIMIZED
  ///
  /// Example:
  /// T;T
  @visibleForTesting
  String stringifyTabs({required DockingTabs tabs}) {
    List<String> data = [];

    // MAXIMIZABLE
    if (tabs.maximizable != null) {
      data.add(tabs.maximizable! ? 'T' : 'F');
    } else {
      data.add('');
    }

    // MAXIMIZED
    data.add(tabs.maximized ? 'T' : 'F');

    return data.join(';');
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

  // 'V1:3:1(R;1.0;;50;2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'
  DockingLayout layoutFrom(String layout) {
    if (layout.startsWith('V1:')) {
      _layout = layout.substring(3);

      // '3:1(R;1.0;;50;2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'
      final int areasLength = _removeFirstRequiredInt(
          stop: ':',
          errorMessage: 'The number of areas could not be identified.');

      Map<int, AreaConfig> areas = {};

      // '1(R;1.0;;50;2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'
      for (int areaIndex = 1; areaIndex <= areasLength; areaIndex++) {
        final int indexFromLayout = _removeFirstRequiredInt(
            stop: '(', errorMessage: 'The area index could not be identified.');
        if (areaIndex != indexFromLayout) {
          throw StateError('Unexpected index: $indexFromLayout');
        }
        // 'R;1.0;;50;2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'
        final String acronym = _removeFirstToken(
            stop: ';',
            errorMessage: 'The area acronym could not be identified.');
        // '1.0;;50;2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'
        final double? weight = _removeFirstOptionalDouble(
            stop: ';', errorMessage: 'Invalid weight.');
        final double? minimalWeight = _removeFirstOptionalDouble(
            stop: ';', errorMessage: 'Invalid minimal weight.');
        final double? minimalSize = _removeFirstOptionalDouble(
            stop: ';', errorMessage: 'Invalid minimal size.');
        // '2,3),2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'

        if (acronym == 'I') {
          //3;idA;0;;6;valueA;T;;F)
        } else if (acronym == 'R') {
          List<int> childrenIndexes = _removeChildrenIndexes();
          areas[areaIndex] = RowConfig(
              weight: weight,
              minimalWeight: minimalWeight,
              minimalSize: minimalSize,
              childrenIndexes: childrenIndexes);
        } else if (acronym == 'C') {
          List<int> childrenIndexes = _removeChildrenIndexes();
          areas[areaIndex] = ColumnConfig(
              weight: weight,
              minimalWeight: minimalWeight,
              minimalSize: minimalSize,
              childrenIndexes: childrenIndexes);
        } else if (acronym == 'T') {
          List<int> childrenIndexes = _removeChildrenIndexes();
        } else {
          throw StateError('Invalid area acronym: $acronym');
        }

        // ',2(I;;;;3;idA;0;;6;valueA;T;;F),3(I;;0.5;;3;idB;0;;6;valueB;T;;F)'
        if (areaIndex == areasLength - 1) {
          if (_removeNext() != ',') {
            throw StateError('?????');
          }
        }
      }

      if (_layout.isNotEmpty) {
        throw StateError('?????');
      }

      return DockingLayout();
    } else {
      if (layout.startsWith('V')) {
        throw StateError('Unsupported layout version.');
      }
      throw StateError('Unable to identify layout version.');
    }
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
}

mixin DefaultLayoutParserMixin {
  /// Default conversion from ID to String.
  String idToString(dynamic id) {
    return id == null ? '' : id.toString();
  }

  /// Default conversion from value to String.
  String valueToString(dynamic value) {
    return value == null ? '' : value.toString();
  }

  /// Default conversion from String to ID.
  dynamic stringToId(String id) {
    return id == '' ? null : id;
  }

  /// Default conversion from String to value.
  dynamic stringToValue(String value) {
    return value == '' ? null : value;
  }
}

class AreaConfig {
  AreaConfig(
      {required this.weight,
      required this.minimalWeight,
      required this.minimalSize});

  double? weight;
  double? minimalWeight;
  double? minimalSize;
}

class ParentConfig extends AreaConfig {
  ParentConfig(
      {required double? weight,
      required double? minimalWeight,
      required double? minimalSize,
      required this.childrenIndexes})
      : super(
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize);

  List<int> childrenIndexes;
}

class RowConfig extends ParentConfig {
  RowConfig(
      {required double? weight,
      required double? minimalWeight,
      required double? minimalSize,
      required List<int> childrenIndexes})
      : super(
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize,
            childrenIndexes: childrenIndexes);
}

class ColumnConfig extends ParentConfig {
  ColumnConfig(
      {required double? weight,
      required double? minimalWeight,
      required double? minimalSize,
      required List<int> childrenIndexes})
      : super(
            weight: weight,
            minimalWeight: minimalWeight,
            minimalSize: minimalSize,
            childrenIndexes: childrenIndexes);
}
