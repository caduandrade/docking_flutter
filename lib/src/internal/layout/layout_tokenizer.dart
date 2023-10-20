import 'package:meta/meta.dart';

/// Tokenizer for the layout string.
@internal
class Tokenizer {
  Tokenizer(String layout) : _layout = layout;

  String _layout;

  String get layout => _layout;

  bool get isNotEmpty => _layout.isNotEmpty;

  bool get isEmpty => _layout.isEmpty;

  String removeNext() {
    if (_layout.isEmpty) {
      throw new StateError('Insufficient characters.');
    }
    final String next = _layout.substring(0, 1);
    _layout = _layout.substring(1);
    return next;
  }

  List<int> removeChildrenIndexes() {
    final String token =
        removeFirstToken(stop: ')', errorMessage: 'Invalid children indexes.');
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

  bool removeFirstRequiredBool(
      {required String stop, required String errorMessage}) {
    final String token =
        removeFirstToken(stop: stop, errorMessage: errorMessage);
    if (token == 'T') {
      return true;
    }
    if (token == 'F') {
      return false;
    }
    throw StateError(errorMessage);
  }

  double? removeFirstOptionalDouble(
      {required String stop, required String errorMessage}) {
    final String token =
        removeFirstToken(stop: stop, errorMessage: errorMessage);
    if (token.isEmpty) {
      return null;
    }
    final double? number = double.tryParse(token);
    if (number == null) {
      throw StateError(errorMessage);
    }
    return number;
  }

  int removeFirstRequiredInt(
      {required String stop, required String errorMessage}) {
    final String token =
        removeFirstToken(stop: stop, errorMessage: errorMessage);
    final int? number = int.tryParse(token);
    if (number == null) {
      throw StateError(errorMessage);
    }
    return number;
  }

  String removeFirstToken(
      {required String stop, required String errorMessage}) {
    final int index = _layout.indexOf(stop);
    if (index == -1) {
      throw StateError(errorMessage);
    }
    final String token = _layout.substring(0, index);
    _layout = _layout.substring(index + 1);
    return token;
  }

  String removeToken({required int length, required String errorMessage}) {
    if (_layout.length < length) {
      throw StateError(errorMessage);
    }
    final String token = _layout.substring(0, length);
    _layout = _layout.substring(length + 1);
    return token;
  }
}
