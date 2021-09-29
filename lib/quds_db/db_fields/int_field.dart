part of '../../quds_db.dart';

/// A db int field representation.
class IntField extends NumField<int> {
  /// Weather the field has auto-increment constrain.
  bool? autoIncrement;

  /// Weather the field has primary-key constrain.
  bool? primaryKey;

  /// Create an instance of [IntField]
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

  /// Get new [IntField] of this value - [other]
  ///
  /// [other] may be of the following:
  ///
  ///  [IntField] - [int]
  IntField operator -(dynamic other) => _getMathOperationQuery('-', other);

  /// Get new [IntField] of this value + [other]
  ///
  /// [other] may be of the following:
  ///
  ///  [IntField] - [int]
  IntField operator +(dynamic other) => _getMathOperationQuery('+', other);

  /// Get new [IntField] of this value / [other]
  ///
  /// [other] may be of the following:
  ///
  ///  [IntField] - [int]
  IntField operator /(dynamic other) => _getMathOperationQuery('/', other);

  /// Get new [IntField] of this value % [other]
  ///
  /// [other] may be of the following:
  ///
  ///  [IntField] - [int]
  IntField operator %(dynamic other) => _getMathOperationQuery('%', other);

  /// Get new [IntField] of this value * [other]
  ///
  /// [other] may be of the following:
  ///
  ///  [IntField] - [int]
  IntField operator *(dynamic other) => _getMathOperationQuery('*', other);

  IntField _getMathOperationQuery(String operation, dynamic other) {
    var result = IntField();
    result.queryBuilder = () =>
        '(' +
        buildQuery() +
        ' $operation ' +
        DbHelper.buildQueryForOperand(other) +
        ')';
    result.parametersBuilder = () => [
          ...getParameters(),
          if (other is QueryPart)
            ...other.getParameters()
          else
            DbHelper.getDbValue(other)
        ];
    return result;
  }

  /// Get sql statement to check weather this field is even.
  ConditionQuery get isEven => (this % 2).equals(0);

  /// Get sql statement to check weather this field is odd.
  ConditionQuery get isOdd => (this % 2).equals(1);

  /// Get new [IntField] object with db `ABS()` function applied.
  IntField abs() {
    var result = IntField();
    result.queryBuilder = () => 'ABS(' + buildQuery() + ')';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get new [IntField] object with db `AVG()` function applied.
  IntField avg() {
    var result = IntField();
    result.queryBuilder = () => 'AVG(' + buildQuery() + ')';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get new [DoubleField] object with this field value.
  DoubleField toDouble() {
    var result = DoubleField();
    result.queryBuilder = () => 'CAST(' + buildQuery() + ' AS REAL)';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get random db integer.
  static IntField get randomInteger {
    var result = IntField();
    result.queryBuilder = () => 'RANDOM()';
    return result;
  }
}
