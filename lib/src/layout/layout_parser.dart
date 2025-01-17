import 'package:multi_split_view/multi_split_view.dart';

/// Parser between DockingLayout and String.
abstract class LayoutParser {
  const LayoutParser();

  /// Converts ID to String.
  String idToString(dynamic id);

  /// Converts String to ID.
  dynamic stringToId(String id);
}

mixin LayoutParserMixin implements LayoutParser {
  /// Default conversion from ID to String.
  String idToString(dynamic id) {
    if (id is AreaId) {
      return '';
    }
    return id == null ? '' : id.toString();
  }

  /// Default conversion from String to ID.
  dynamic stringToId(String id) {
    return id == '' ? null : id;
  }
}
