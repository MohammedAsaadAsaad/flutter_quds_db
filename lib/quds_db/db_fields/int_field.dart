import '../../quds_db.dart';

class IntField extends NumField<int> {
  bool? autoIncrement;
  bool? primaryKey;
  IntField(
      {String? columnName,
      this.autoIncrement,
      this.primaryKey,
      bool? notNull,
      int? defaultValue,
      bool? isUnique,
      String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: int) {
    value = defaultValue;
  }

  @override
  String get columnDefinition {
    String result = super.columnDefinition;
    if (primaryKey == true) result += ' PRIMARY KEY';
    if (autoIncrement == true) result += ' AUTOINCREMENT';
    return result;
  }

  IntField operator -(dynamic other) => _getMathOperationQuery('-', other);
  IntField operator +(dynamic other) => _getMathOperationQuery('+', other);
  IntField operator /(dynamic other) => _getMathOperationQuery('/', other);
  IntField operator %(dynamic other) => _getMathOperationQuery('%', other);
  IntField operator *(dynamic other) => _getMathOperationQuery('*', other);

  IntField _getMathOperationQuery(String operation, dynamic other) {
    var result = IntField();
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

  ConditionQuery get isEven => (this % 2).equals(0);
  ConditionQuery get isOdd => (this % 2).equals(1);

  IntField abs() {
    var result = IntField();
    result.queryBuilder = () => 'ABS(' + this.buildQuery() + ')';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  IntField avg() {
    var result = IntField();
    result.queryBuilder = () => 'AVG(' + this.buildQuery() + ')';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  DoubleField toDouble() {
    var result = DoubleField();
    result.queryBuilder = () => 'CAST(' + this.buildQuery() + ' AS REAL)';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  static IntField get randomInteger {
    var result = IntField();
    result.queryBuilder = () => 'RANDOM()';
    return result;
  }
}
