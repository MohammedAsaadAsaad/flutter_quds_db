import 'int_field.dart';

class IdField extends IntField {
  IdField([String columnName = 'id'])
      : super(
          autoIncrement: true,
          primaryKey: true,
          columnName: columnName,
        );
}
