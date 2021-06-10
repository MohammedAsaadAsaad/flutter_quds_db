part of '../../quds_db.dart';

/// DateTime db field representation.
///
/// It's being stored as integer in the db.
class DateTimeField extends FieldWithValue<DateTime> {
  /// Create an instance of [DateTimeField]
  DateTimeField(
      {String? columnName, bool? notNull, bool? isUnique, String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: DateTime);

  /// Get db order statement to order from older to newer dates
  FieldOrder get earlierOrder => this.ascOrder;

  /// Get db order statement to order from newer to older dates
  FieldOrder get laterOrder => this.descOrder;

  /// Get db statement to check if this value more than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery moreThan(dynamic other) {
    return ConditionQuery(operatorString: '>', before: this, after: other);
  }

  /// Get db statement to check if this value less than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery lessThan(dynamic other) {
    return ConditionQuery(operatorString: '<', before: this, after: other);
  }

  /// Get db statement to check if this value more than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery moreThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '>=', before: this, after: other);
  }

  /// Get db statement to check if this value less than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery lessThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '<=', before: this, after: other);
  }

  /// Get db statement to check if this value more than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery operator >(dynamic other) => moreThan(other);

  /// Get db statement to check if this value more than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery operator >=(dynamic other) => moreThanOrEquals(other);

  /// Get db statement to check if this value less than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery operator <(dynamic other) => lessThan(other);

  /// Get db statement to check if this value less than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeField]
  ConditionQuery operator <=(dynamic other) => lessThanOrEquals(other);

  /// Get db statement to check if this value is between two dates,
  ///
  /// [min] and [max] may be [DateTime] object or [DateTimeField]
  ConditionQuery between(dynamic min, dynamic max) {
    DbFunctions.assertDateTimesValues([min, max]);
    var q = ConditionQuery();
    String qString = '(${this.buildQuery()} BETWEEN ';
    qString += (min is DateTimeField) ? min.buildQuery() : '?';
    qString += ' AND ';
    qString += (max is DateTimeField) ? max.buildQuery() : '?';
    qString += ')';
    q.queryBuilder = () => qString;
    q.parametersBuilder = () => [
          ...this.getParameters(),
          if (min is NumField)
            ...min.getParameters()
          else
            (min as DateTime).millisecondsSinceEpoch,
          if (max is NumField)
            ...max.getParameters()
          else
            (max as DateTime).millisecondsSinceEpoch
        ];
    return q;
  }
}
