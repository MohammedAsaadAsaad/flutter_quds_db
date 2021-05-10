import '../../quds_db.dart';

class DateTimeStringField extends FieldWithValue<DateTime> {
  DateTimeStringField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      DateTime? defaultValue,
      String? jsonMapName})
      : super(columnName,
            defaultValue: defaultValue,
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
    DbFunctions.assertDateTimeStringsValues([min, max]);
    var q = ConditionQuery();
    String qString = '(${this.buildQuery()} BETWEEN ';
    qString += (min is DateTimeStringField) ? min.buildQuery() : '?';
    qString += ' AND ';
    qString += (max is DateTimeStringField) ? max.buildQuery() : '?';
    qString += ')';
    q.queryBuilder = () => qString;
    q.parametersBuilder = () => [
          ...this.getParameters(),
          if (min is NumField)
            ...min.getParameters()
          else
            (min as DateTime).toString(),
          if (max is NumField)
            ...max.getParameters()
          else
            (max as DateTime).toString()
        ];
    return q;
  }

  IntField get dayOfYear => _componentAsInteger('j');
  IntField get fractionalSecond => _componentAsInteger('f');
  IntField get hour => _componentAsInteger('H');
  IntField get minute => _componentAsInteger('M');
  IntField get second => _componentAsInteger('S');
  IntField get secondFromEpoch => _componentAsInteger('s');
  IntField get dayOfWeek => _componentAsInteger('w');
  IntField get weekOfYear => _componentAsInteger('W');
  IntField get julianDay => _componentAsInteger('J');

  IntField get day => _componentAsInteger('d');
  StringField get dayAsString => _componentAsString('d');

  IntField get month => _componentAsInteger('m');
  StringField get monthAsString => _componentAsString('m');

  IntField get year => _componentAsInteger('Y');
  StringField get yearAsString => _componentAsString('Y');

  IntField _componentAsInteger(String format) {
    var result = IntField();
    result.queryBuilder =
        () => "CAST(STRFTIME('%$format', ${this.buildQuery()}) AS INTEGER)";
    result.parametersBuilder = () => [...this.getParameters()];
    return result;
  }

  StringField _componentAsString(String format) {
    var result = StringField();
    result.queryBuilder = () => "STRFTIME('%$format', ${this.buildQuery()})";
    result.parametersBuilder = () => [...this.getParameters()];
    return result;
  }

  ConditionQuery isSameDayAndMonth(DateTime d) {
    return this.day.equals(d.day) & this.month.equals(d.month);
  }

  @override
  get dbValue => value == null ? null : value.toString();

  @override
  set dbValue(dynamic v) {
    value = v == null ? null : DateTime.parse(v);
  }

  @override
  String get columnDefinition {
    String result = '$columnName TEXT';
    if (notNull == true) result += ' NOT NULL';
    if (isUnique == true) result += ' UNIQUE';
    return result;
  }

  DateTimeStringField get datePart {
    var result = DateTimeStringField();
    result.queryBuilder = () => "DATE(${this.buildQuery()})";
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  ConditionQuery isBirthday() {
    var now = DateTimeStringField.now;
    var result = ConditionQuery();
    result.queryBuilder = () =>
        (this.day.equals(now.day) & this.month.equals(now.month)).buildQuery();
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  IntField get age {
    var result = IntField();
    result.queryBuilder = () =>
        "(strftime('%Y', 'now') - strftime('%Y', ${this.buildQuery()})) - (strftime('%m-%d', 'now') < strftime('%m-%d', ${this.buildQuery()}))";
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  DateTimeStringField get timePart {
    var result = DateTimeStringField();
    result.queryBuilder = () => "TIME(${this.buildQuery()})";
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  static DateTimeStringField get now {
    var result = DateTimeStringField();
    result.queryBuilder = () => "DATETIME('now')";
    result.parametersBuilder = () => [];
    return result;
  }
}
