part of '../../quds_db.dart';

/// A json db field representation.
class _JsonField<T> extends FieldWithValue<T> {
  /// Create an instance of [JsonField]
  _JsonField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      T? defaultValue})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: String) {
    value = defaultValue == null ? null : defaultValue as T;
  }

  // IntField get arrayLength {
  //   var result = IntField();
  //   result.queryBuilder = () => 'json_array_length(' + this.buildQuery() + ')';
  //   result.parametersBuilder = () => this.getParameters();
  //   return result;
  // }
}

class ListField extends _JsonField<List> {
  // Create an instance of [JsonField]
  ListField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      List? defaultValue})
      : super(
            columnName: columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            defaultValue: defaultValue);
}

class JsonField extends _JsonField<Map> {
  // Create an instance of [JsonField]
  JsonField({
    String? columnName,
    bool? notNull,
    bool? isUnique,
    String? jsonMapName,
    Map? defaultValue,
  }) : super(
            columnName: columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            defaultValue: defaultValue);
}
