import '../../quds_db.dart';

class NumField<T> extends FieldWithValue<T> {
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

  ConditionQuery moreThan(dynamic other) {
    return ConditionQuery(operatorString: '>', before: this, after: other);
  }

  ConditionQuery lessThan(dynamic other) {
    return ConditionQuery(operatorString: '<', before: this, after: other);
  }

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

  IntField round([int? digits]) {
    var result = IntField();
    result.queryBuilder = () =>
        'ROUND(' + this.buildQuery() + (digits == null ? ')' : ',$digits)');
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  DoubleField max() {
    return DbFunctions.max(this);
  }

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
