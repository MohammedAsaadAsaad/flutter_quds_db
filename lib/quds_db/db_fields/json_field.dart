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
}

class ListField extends _JsonField<List> {
  // Create an instance of [ListField]
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

  IntField get length {
    IntField result = IntField();
    result.queryBuilder = () => 'json_array_length(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }
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

  BoolField containsKey(String key) {
    BoolField result = BoolField();
    result.queryBuilder = () => 'contains_key(${this.buildQuery()},?)';
    result.parametersBuilder = () => [...this.getParameters(), key];
    return result;
  }

  BoolField keyEquals(String key, dynamic value) {
    BoolField result = BoolField();
    result.queryBuilder = () => 'key_equals(${this.buildQuery()},?,?)';
    result.parametersBuilder = () => [...this.getParameters(), key, value];
    return result;
  }
}
