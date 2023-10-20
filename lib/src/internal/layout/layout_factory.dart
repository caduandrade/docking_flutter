import 'package:docking/src/internal/layout/layout_tokenizer.dart';
import 'package:docking/src/layout/area_builder.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/layout_parser.dart';
import 'package:meta/meta.dart';

@internal
class LayoutFactory {
  /// Builds a [DockingLayout] from formatted layout String.
  static DockingArea? buildRoot(
      {required String layout,
      required LayoutParser parser,
      required AreaBuilder builder}) {
    if (layout.startsWith('V1:')) {
      Tokenizer tokenizer = Tokenizer(layout.substring(3));

      final int areasLength = tokenizer.removeFirstRequiredInt(
          stop: ':',
          errorMessage: 'The number of areas could not be identified.');

      Map<int, _AreaConfig> areas = {};

      for (int areaIndex = 1; areaIndex <= areasLength; areaIndex++) {
        final int indexFromLayout = tokenizer.removeFirstRequiredInt(
            stop: '(',
            errorMessage: 'The area index could not be identified: $areaIndex');
        if (areaIndex != indexFromLayout) {
          throw StateError('Unexpected index: $indexFromLayout');
        }
        final String acronym = tokenizer.removeFirstToken(
            stop: ';',
            errorMessage: 'The area acronym could not be identified.');

        final int idLength = tokenizer.removeFirstRequiredInt(
            stop: ';',
            errorMessage:
                'Error reading area $areaIndex. Not found: id length.');
        final String id = tokenizer.removeToken(
            length: idLength,
            errorMessage: 'Error reading area $areaIndex. Not found: id.');

        final double? weight = tokenizer.removeFirstOptionalDouble(
            stop: ';', errorMessage: 'Invalid weight.');

        if (acronym == 'I') {
          final bool maximized = tokenizer.removeFirstRequiredBool(
              stop: ')',
              errorMessage:
                  'Error reading area $areaIndex. Not found: maximized.');
          areas[areaIndex] =
              _ItemConfig(id: id, weight: weight, maximized: maximized);
        } else if (acronym == 'R') {
          List<int> childrenIndexes = tokenizer.removeChildrenIndexes();
          areas[areaIndex] = _RowConfig(
              id: id, weight: weight, childrenIndexes: childrenIndexes);
        } else if (acronym == 'C') {
          List<int> childrenIndexes = tokenizer.removeChildrenIndexes();
          areas[areaIndex] = _ColumnConfig(
              id: id, weight: weight, childrenIndexes: childrenIndexes);
        } else if (acronym == 'T') {
          final bool maximized = tokenizer.removeFirstRequiredBool(
              stop: ';', errorMessage: 'Unrecognized syntax.');
          List<int> childrenIndexes = tokenizer.removeChildrenIndexes();
          areas[areaIndex] = _TabsConfig(
              id: id,
              weight: weight,
              maximized: maximized,
              childrenIndexes: childrenIndexes);
        } else {
          throw StateError('Invalid area acronym: $acronym');
        }

        if (areaIndex < areasLength) {
          if (tokenizer.removeNext() != ',') {
            throw StateError('Unrecognized syntax. Area separator not found.');
          }
        }
      }

      if (tokenizer.isNotEmpty) {
        throw StateError('Unrecognized syntax: ${tokenizer.layout}');
      }

      if (areasLength == 0) {
        return null;
      }
      final _AreaConfig rootConfig = areas.getArea(1);
      return _buildArea(
          parser: parser, builder: builder, parent: rootConfig, areas: areas);
    } else {
      if (layout.startsWith('V')) {
        throw StateError('Unsupported layout version.');
      }
      throw StateError('Unable to identify layout version.');
    }
  }

  static DockingArea _buildArea(
      {required LayoutParser parser,
      required AreaBuilder builder,
      required _AreaConfig parent,
      required Map<int, _AreaConfig> areas}) {
    if (parent is _ItemConfig) {
      return builder.buildDockingItem(
          id: parser.stringToId(parent.id),
          weight: parent.weight,
          maximized: parent.maximized);
    } else if (parent is _ParentConfig) {
      List<DockingArea> children = [];
      parent.childrenIndexes.forEach((childIndex) {
        final _AreaConfig childConfig = areas.getArea(childIndex);
        children.add(_buildArea(
            parser: parser,
            builder: builder,
            parent: childConfig,
            areas: areas));
      });
      if (parent is _RowConfig) {
        return builder.buildDockingRow(
            id: parser.stringToId(parent.id),
            weight: parent.weight,
            children: children);
      } else if (parent is _ColumnConfig) {
        return builder.buildDockingColumn(
            id: parser.stringToId(parent.id),
            weight: parent.weight,
            children: children);
      }
      if (parent is _TabsConfig) {
        List<DockingItem> items = [];
        for (DockingArea area in children) {
          items.add(area as DockingItem);
        }
        return builder.buildDockingTabs(
            id: parser.stringToId(parent.id),
            weight: parent.weight,
            maximized: parent.maximized,
            children: items);
      }
    }
    throw StateError('Unrecognized type: ${parent.runtimeType}');
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
