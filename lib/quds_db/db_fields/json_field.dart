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
    result.queryBuilder = () => 'json_array_length(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  ListField removeAt(int index) {
    ListField result = ListField();
    result.queryBuilder = () => 'json_array_remove(${buildQuery()},?)';
    result.parametersBuilder = () => [...getParameters(), index];
    return result;
  }

  ListField insertAt(int index, dynamic element) {
    ListField result = ListField();
    result.queryBuilder = () => 'json_array_insert(${buildQuery()},?,?)';
    result.parametersBuilder = () => [...getParameters(), index, element];
    return result;
  }

  ListField add(dynamic element) {
    ListField result = ListField();
    result.queryBuilder = () => 'json_array_add(${buildQuery()},?)';
    result.parametersBuilder = () => [...getParameters(), element];
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
    result.queryBuilder = () => 'contains_key(${buildQuery()},?)';
    result.parametersBuilder = () => [...getParameters(), key];
    return result;
  }

  BoolField keyEquals(String key, dynamic value) {
    BoolField result = BoolField();
    result.queryBuilder = () => 'key_equals(${buildQuery()},?,?)';
    result.parametersBuilder = () => [...getParameters(), key, value];
    return result;
  }

  StringField asStringFieldForQuery() => StringField(columnName: columnName);
}
