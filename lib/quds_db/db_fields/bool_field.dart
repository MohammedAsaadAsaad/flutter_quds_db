import '../../quds_db.dart';

class BoolField extends FieldWithValue<bool> {
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

  ConditionQuery get isTrue => equals(true);
  ConditionQuery get isFalse => equals(false);
  ConditionQuery get isNotFalse => notEquals(false);
  ConditionQuery get isNotTrue => notEquals(true);
}
