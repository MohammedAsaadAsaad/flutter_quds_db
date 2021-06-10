part of '../../quds_db.dart';

/// An [IntField] with id field constrains
class IdField extends IntField {
  /// Create an instance of [IdField]
  IdField([String columnName = 'id'])
      : super(
          autoIncrement: true,
          primaryKey: true,
          columnName: columnName,
        );
}
