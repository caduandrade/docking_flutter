import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/typedef_parsers.dart';
import 'package:meta/meta.dart';

/// Parser from DockingLayout to String.
class LayoutParser {
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
  String stringify(
      {required DockingLayout layout,
      IdToString? idToString,
      ValueToString? valueToString}) {
    final List<DockingArea> areas = layout.layoutAreas();

    String str = 'V1:${areas.length}:';
    for (int i = 0; i < areas.length; i++) {
      if (i > 0) {
        str += ',';
      }
      final DockingArea area = areas[i];
      str += '${area.index}(';
      str += '${area.areaAcronym};';
      str += '${stringifyArea(area: area)};';

      if (area is DockingItem) {
        str += stringifyItem(
            item: area,
            idToString: idToString ?? defaultIdToString,
            valueToString: valueToString ?? defaultValueToString);
      } else if (area is DockingTabs) {
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
  String stringifyItem(
      {required DockingItem item,
      required IdToString idToString,
      required ValueToString valueToString}) {
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

  /// Default conversion from ID to String.
  static String defaultIdToString(dynamic id) {
    if (id == null) {
      return '';
    }
    return id.toString();
  }

  /// Default conversion from ID to String.
  static String defaultValueToString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }
}
