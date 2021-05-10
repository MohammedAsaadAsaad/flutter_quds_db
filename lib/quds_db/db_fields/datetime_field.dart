import '../../quds_db.dart';

class DateTimeField extends FieldWithValue<DateTime> {
  DateTimeField(
      {String? columnName, bool? notNull, bool? isUnique, String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: DateTime);

  OrderField get earlierOrder => this.ascOrder;
  OrderField get laterOrder => this.descOrder;

  ConditionQuery moreThan(dynamic other) {
    return ConditionQuery(operatorString: '>', before: this, after: other);
  }

  ConditionQuery lessThan(dynamic other) {
    return ConditionQuery(operatorString: '<', before: this, after: other);
  }

  ConditionQuery moreThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '>=', before: this, after: other);
  }

  ConditionQuery lessThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '<=', before: this, after: other);
  }

  ConditionQuery operator >(dynamic other) => moreThan(other);
  ConditionQuery operator >=(dynamic other) => moreThanOrEquals(other);
  ConditionQuery operator <(dynamic other) => lessThan(other);
  ConditionQuery operator <=(dynamic other) => lessThanOrEquals(other);

  ConditionQuery between(min, max) {
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
