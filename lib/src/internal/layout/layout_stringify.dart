import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_parser.dart';
import 'package:meta/meta.dart';

@internal
class LayoutStringify {
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
  static String stringify(
      {required LayoutParser parser, required List<DockingArea> areas}) {
    String str = 'V1:${areas.length}:';
    for (int i = 0; i < areas.length; i++) {
      if (i > 0) {
        str += ',';
      }
      final DockingArea area = areas[i];
      str += '${area.index}(';
      str += '${area.areaAcronym};';
      str += '${stringifyArea(parser: parser, area: area)}';

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
  static String stringifyArea(
      {required LayoutParser parser, required DockingArea area}) {
    List<String> data = [];
    // ID_LENGTH and ID
    final String id = parser.idToString(area.id);
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
  static String stringifyItem({required DockingItem item}) {
    return item.maximized ? 'T' : 'F';
  }

  /// Converts the [DockingTabs] configuration into a String with the
  /// following data:
  /// * MAXIMIZED
  ///
  /// Example:
  /// T
  static String stringifyTabs({required DockingTabs tabs}) {
    return tabs.maximized ? 'T' : 'F';
  }

  /// Converts the children indexes to String separated by colon.
  ///
  /// Example:
  /// 4,5,6
  static String stringifyParent({required DockingParentArea parent}) {
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
}
