part of '../../quds_db.dart';

/// DateTime db field representation.
///
/// It's being stored as string in the db.
///
/// [DateTimeStringField] supports several db functions.
class DateTimeStringField extends FieldWithValue<DateTime> {
  /// Create an instance of [DateTimeStringField]
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

  /// Get db order statement to order from older to newer dates
  FieldOrder get earlierOrder => this.ascOrder;

  /// Get db order statement to order from newer to older dates
  FieldOrder get laterOrder => this.descOrder;

  /// Get db statement to check if this value more than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery moreThan(dynamic other) {
    return ConditionQuery(operatorString: '>', before: this, after: other);
  }

  /// Get db statement to check if this value less than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery lessThan(dynamic other) {
    return ConditionQuery(operatorString: '<', before: this, after: other);
  }

  /// Get db statement to check if this value more than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery moreThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '>=', before: this, after: other);
  }

  /// Get db statement to check if this value less than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery lessThanOrEquals(dynamic other) {
    return ConditionQuery(operatorString: '<=', before: this, after: other);
  }

  /// Get db statement to check if this value more than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery operator >(dynamic other) => moreThan(other);

  /// Get db statement to check if this value more than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery operator >=(dynamic other) => moreThanOrEquals(other);

  /// Get db statement to check if this value less than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery operator <(dynamic other) => lessThan(other);

  /// Get db statement to check if this value less than or equal another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery operator <=(dynamic other) => lessThanOrEquals(other);

  /// Get db statement to check if this value less than another date,
  ///
  /// [other] may be [DateTime] object or [DateTimeStringField]
  ConditionQuery between(dynamic min, dynamic max) {
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

  /// Get [IntField] with value of this field year component.
  IntField get dayOfYear => _componentAsInteger('j');

  /// Get [IntField] with value of this field fractional second component.
  IntField get fractionalSecond => _componentAsInteger('f');

  /// Get [IntField] with value of this field hour component.
  IntField get hour => _componentAsInteger('H');

  /// Get [IntField] with value of this field minute component.
  IntField get minute => _componentAsInteger('M');

  /// Get [IntField] with value of this field second component.
  IntField get second => _componentAsInteger('S');

  /// Get [IntField] with value of this field seconds from Epoch.
  IntField get secondFromEpoch => _componentAsInteger('s');

  /// Get [IntField] with value of this field day of week.
  IntField get dayOfWeek => _componentAsInteger('w');

  /// Get [IntField] with value of this field week of year.
  IntField get weekOfYear => _componentAsInteger('W');

  /// Get [IntField] with value of this field julian day.
  IntField get julianDay => _componentAsInteger('J');

  /// Get [IntField] with value of this field day component.
  ///
  /// In another words `day of month`
  IntField get day => _componentAsInteger('d');

  /// Get [StringField] with day part as string.
  StringField get dayAsString => _componentAsString('d');

  /// Get [IntField] with value of this field month component.
  IntField get month => _componentAsInteger('m');

  /// Get [StringField] with month part as string.
  StringField get monthAsString => _componentAsString('m');

  /// Get [IntField] with value of this field year component.
  IntField get year => _componentAsInteger('Y');

  /// Get [StringField] with year part as string.
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

  /// Get db statement to check weather this field has same day and month parts of another [DateTime] object.
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

  /// Get the db date part of this value.
  DateTimeStringField get datePart {
    var result = DateTimeStringField();
    result.queryBuilder = () => "DATE(${this.buildQuery()})";
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  /// Get a statement to check weather now has same day and month of this value.
  ConditionQuery isBirthday() {
    var now = DateTimeStringField.now;
    var result = ConditionQuery();
    result.queryBuilder = () =>
        (this.day.equals(now.day) & this.month.equals(now.month)).buildQuery();
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  /// Get a statement to check weather now has same date part of this value.
  ConditionQuery isSameDatePart(DateTime d) {
    var result = ConditionQuery();
    result.queryBuilder = () => (this.day.equals(d.day) &
            this.month.equals(d.month) &
            this.year.equals(d.year))
        .buildQuery();
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  /// Get an [IntField] with age calculated.
  IntField get age {
    var result = IntField();
    result.queryBuilder = () =>
        "(strftime('%Y', 'now') - strftime('%Y', ${this.buildQuery()})) - (strftime('%m-%d', 'now') < strftime('%m-%d', ${this.buildQuery()}))";
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  /// Get the db time part of this value.
  DateTimeStringField get timePart {
    var result = DateTimeStringField();
    result.queryBuilder = () => "TIME(${this.buildQuery()})";
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  /// Get a [DateTimeStringField] with `now` db representation.
  static DateTimeStringField get now {
    var result = DateTimeStringField();
    result.queryBuilder = () => "DATETIME('now')";
    result.parametersBuilder = () => [];
    return result;
  }
}
