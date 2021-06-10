part of '../../quds_db.dart';

/// A bool db field representation.
class BoolField extends FieldWithValue<bool> {
  /// Create an instance of [BoolField]
  BoolField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      bool? defaultValue,
      String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            defaultValue: defaultValue,
            jsonMapName: jsonMapName,
            jsonMapType: bool);

  /// Get [ConditionQuery] object to detect if this value is [true] in the db.
  ConditionQuery get isTrue => equals(true);

  /// Get [ConditionQuery] object to detect if this value is [false] in the db.
  ConditionQuery get isFalse => equals(false);

  /// Get [ConditionQuery] object to detect if this value is not [false] in the db.
  ConditionQuery get isNotFalse => notEquals(false);

  /// Get [ConditionQuery] object to detect if this value is not [true] in the db.
  ConditionQuery get isNotTrue => notEquals(true);
}
