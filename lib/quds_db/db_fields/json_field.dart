part of '../../quds_db.dart';

/// A json db field representation.
class JsonField extends FieldWithValue<Map> {
  /// Create an instance of [JsonField]
  JsonField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      Map? defaultValue})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: String) {
    value = defaultValue;
  }
}
