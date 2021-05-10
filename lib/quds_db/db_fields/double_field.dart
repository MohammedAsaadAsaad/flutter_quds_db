import '../../quds_db.dart';

class DoubleField extends NumField<double> {
  DoubleField(
      {String? columnName, bool? notNull, bool? isUnique, String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: double);

  DoubleField operator -(dynamic other) => _getMathOperationQuery('-', other);
  DoubleField operator +(dynamic other) => _getMathOperationQuery('+', other);
  DoubleField operator /(dynamic other) => _getMathOperationQuery('/', other);
  DoubleField operator *(dynamic other) => _getMathOperationQuery('*', other);

  DoubleField _getMathOperationQuery(String operation, dynamic other) {
    var result = DoubleField();
    result.queryBuilder = () =>
        '(' +
        this.buildQuery() +
        ' $operation ' +
        DbHelper.buildQueryForOperand(other) +
        ')';
    result.parametersBuilder = () => [
          ...this.getParameters(),
          if (other is QueryPart)
            ...other.getParameters()
          else
            DbHelper.getDbValue(other)
        ];
    return result;
  }

  DoubleField abs() {
    var result = DoubleField();
    result.queryBuilder = () => 'ABS(' + this.buildQuery() + ')';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  IntField toInt() {
    var result = IntField();
    result.queryBuilder =
        () => 'CAST(ROUND(' + this.buildQuery() + ') AS INTEGER)';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }
}
