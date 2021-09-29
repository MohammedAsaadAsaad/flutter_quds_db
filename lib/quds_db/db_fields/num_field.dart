part of '../../quds_db.dart';

/// A num db representation, may be `integer` or `double`.
class NumField<T> extends FieldWithValue<T> {
  /// Create an instance of [NumField]
  NumField(String? columnName,
      {bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      Type jsonMapType = num})
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
    String qString = '(${buildQuery()} BETWEEN ';
    qString += (min is NumField) ? min.buildQuery() : '?';
    qString += ' AND ';
    qString += (max is NumField) ? max.buildQuery() : '?';
    qString += ')';
    q.queryBuilder = () => qString;
    q.parametersBuilder = () => [
          ...getParameters(),
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
        'ROUND(' + buildQuery() + (digits == null ? ')' : ',$digits)');
    result.parametersBuilder = () => getParameters();
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

  /// Get db value with `SIN(X)` function applied.
  DoubleField sin() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'SIN(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `COS(X)` function applied.
  DoubleField cos() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'COS(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `TAN(X)` function applied.
  DoubleField tan() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'TAN(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `ASIN(X)` function applied.
  DoubleField asin() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'ASIN(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `ACOS(X)` function applied.
  DoubleField acos() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'ACOS(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `ATAN(X)` function applied.
  DoubleField atan() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'ATAN(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `ATAN2(X,Y)` function applied.
  ///
  /// Return the arctangent of Y/X. The result is in radians. The result is placed into correct quadrant depending on the signs of X and Y.
  DoubleField atan2(num y) {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'ATAN2(${buildQuery()},?)';
    result.parametersBuilder = () => [...getParameters(), y];
    return result;
  }

  /// Convert from radians into degrees.
  DoubleField toDegrees() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'DEGREES(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `CEIL(X)` function applied.
  DoubleField ceil() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'CEIL(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `FLOOR(X)` function applied.
  DoubleField floor() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'FLOOR(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `EXP(X)` function applied.
  ///
  /// Compute e (Euler's number, approximately 2.71828182845905) raised to the power X.
  DoubleField exp() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'EXP(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Convert from degrees into radians.
  DoubleField toRadians() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'RADIANS(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `LOG(X)` function applied.
  ///
  /// Return the base-10 logarithm for X.
  DoubleField log() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'LOG(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `LN(X)` function applied.
  ///
  /// Return the natural logarithm for X.
  DoubleField ln() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'LN(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `LOG10(X)` function applied.
  ///
  /// Return the base-10 logarithm for X.
  DoubleField log10() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'LOG10(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `LOG2(X)` function applied.
  ///
  /// Return the base-2 logarithm for X.
  DoubleField log2() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'LOG2(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get db value with `LOG_B(base,X)` function applied.
  ///
  /// Return the `base` logarithm for X.
  DoubleField logB(num base) {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'LOG_B(?,${buildQuery()})';
    result.parametersBuilder = () => [base, ...getParameters()];
    return result;
  }

  /// Get db value with `POW(X,power)` function applied.
  ///
  /// Return X powered to `power`
  DoubleField powerTo(num power) {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'POW(${buildQuery()},?)';
    result.parametersBuilder = () => [...getParameters(), power];
    return result;
  }

  /// Get db value with `SQRT(X)` function applied.
  DoubleField sqrt() {
    DoubleField result = DoubleField();
    result.queryBuilder = () => 'SQRT(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }
}
