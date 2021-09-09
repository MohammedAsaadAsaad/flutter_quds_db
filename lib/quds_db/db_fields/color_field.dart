part of '../../quds_db.dart';

/// Color db field representation.
class ColorField extends FieldWithValue<Color> {
  /// Create an instance of [ColorField]
  ColorField(
      {String? columnName, bool? notNull, bool? isUnique, String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: Color);
}
