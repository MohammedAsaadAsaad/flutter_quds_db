part of '../../quds_db.dart';

/// A num db representation, may be `integer` or `double`.
class NumField<T> extends FieldWithValue<T> {
  /// Create an instance of [NumField]
  NumField(String? columnName,
      {bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      Type jsonMapType: num})
      : super(columnName,
            notNull: notNull,
            isUnique: notNull,
            jsonMapName: jsonMapName,
            jsonMapType: jsonMapType);

  /// Get a sql statement representation that check weather this value is more than [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery moreThan(dynamic other) {
    return ConditionQuery(operatorString: '>', before: this, after: other);
  }

  /// Get a sql statement representation that check weather this value is less than [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery lessThan(dynamic other) {
    return ConditionQuery(operatorString: '<', before: this, after: other);
  }

  /// Get a sql statement representation that check weather this value is between two values.
  ///
  /// [min],[max] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery between(min, max) {
    DbFunctions.assertNumValues([min, max]);
    var q = ConditionQuery();
    String qString = '(${this.buildQuery()} BETWEEN ';
    qString += (min is NumField) ? min.buildQuery() : '?';
    qString += ' AND ';
    qString += (max is NumField) ? max.buildQuery() : '?';
    qString += ')';
    q.queryBuilder = () => qString;
    q.parametersBuilder = () => [
          ...this.getParameters(),
          if (min is NumField) ...min.getParameters() else min,
          if (max is NumField) ...max.getParameters() else max
        ];
    return q;
  }

  /// Get a sql statement representation that check weather this value is more than or equal [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery moreThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '>=', before: this, after: other);
  }

  /// Get a sql statement representation that check weather this value is less than or equal [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery lessThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '<=', before: this, after: other);
  }

  /// Get a sql statement representation that check weather this value is more than [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery operator >(dynamic other) => moreThan(other);

  /// Get a sql statement representation that check weather this value is more than or equal [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery operator >=(dynamic other) => moreThanOrEquals(other);

  /// Get a sql statement representation that check weather this value is less than [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery operator <(dynamic other) => lessThan(other);

  /// Get a sql statement representation that check weather this value is less than or equal [other].
  ///
  /// [other] may be of the following:
  ///
  ///  [DoubleField] - [IntField] - [NumField] - [double] - [int]
  ConditionQuery operator <=(dynamic other) => lessThanOrEquals(other);

  /// Get a db field with this value rounded to [digits] decimals.
  DoubleField round([int? digits]) {
    var result = DoubleField();
    result.queryBuilder = () =>
        'ROUND(' + this.buildQuery() + (digits == null ? ')' : ',$digits)');
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  /// Get db value with `MAX()` function applied.
  DoubleField max() {
    return DbFunctions.max(this);
  }

  /// Get db value with `MIN()` function applied.
  DoubleField min() {
    return DbFunctions.min(this);
  }

  // DoubleField sin() {
  //   DoubleField result = DoubleField();
  //   result.queryBuilder = () => 'SIN(${this.buildQuery()})';
  //   result.parametersBuilder = () => this.getParameters();
  //   return result;
  // }

}
