part of '../quds_db.dart';

/// Provides some db functions like `MAX` - `MIN` - `IFNULL` ... etc.
class DbFunctions {
  /// To prevent creating instances of [DbFunctions].
  DbFunctions._();

  /// Assert each entry of [values] is not null.
  static void assertNotNullValues(List values) => values.forEach((element) {
        assert(element != null);
      });

  /// Assert each entry of [values] is [num] or [NumField].
  static void assertNumValues(List values) {
    assertNotNullValues(values);
    for (var v in values) assert(v is num || v is NumField);
  }

  /// Assert each entry of [values] is [String] or [StringField].
  static void assertStringValues(List values) {
    assertNotNullValues(values);
    for (var v in values) assert(v is String || v is StringField);
  }

  static String _buildListQuery(List values) {
    String result = '';
    for (var v in values)
      result += (v is FieldWithValue ? v.buildQuery() : '?') + ',';
    if (result.endsWith(',')) result = result.substring(0, result.length - 1);
    return result;
  }

  static List _buildParametersList(List values) {
    List result = [];
    for (var v in values)
      if (!(v is FieldWithValue)) result.add(DbHelper.getDbValue(v));
    return result;
  }

  static DoubleField _buildCollectionNumValuesFunction(
    String functionName,
    List values,
  ) {
    assertNumValues(values);
    DoubleField result = DoubleField();
    result.queryBuilder =
        () => '$functionName(' + _buildListQuery(values) + ')';
    result.parametersBuilder = () => _buildParametersList(values);
    return result;
  }

  static StringField _buildCollectionStringValuesFunction(
    String functionName,
    List values,
  ) {
    assertStringValues(values);
    StringField result = StringField();
    result.queryBuilder =
        () => '$functionName(' + _buildListQuery(values) + ')';
    result.parametersBuilder = () => _buildParametersList(values);
    return result;
  }

  /// Create sql statement with function `MAX()` function applied.
  static DoubleField max(NumField f) =>
      _buildCollectionNumValuesFunction('MAX', [f]);

  /// Create sql statement with function `MIN()` function applied.
  static DoubleField min(NumField f) =>
      _buildCollectionNumValuesFunction('MIN', [f]);

  /// Create sql statement with function `SUM()` function applied.
  static DoubleField sum(List values) =>
      _buildCollectionNumValuesFunction('SUM', values);

  /// Create sql statement with function `COUNT()` function applied.
  static DoubleField count(List values) =>
      _buildCollectionNumValuesFunction('COUNT', values);

  // static DoubleField avg(List values) =>
  //     _buildCollectionNumValuesFunction('AVG', values);

  /// Create sql statement with function `GROUP_CONCAT()` function applied for several values,
  /// values may be [String] or [StringField]
  static StringField concatGroup(List values) =>
      _buildCollectionStringValuesFunction('GROUP_CONCAT', values);

  /// Create sql statement with function `COALESCE()` function applied for several values,
  /// values may be [String] or [StringField]
  ///
  /// `COALESCE()` is used to get first not null value of [values], if all values are null,
  /// it returns null.
  static StringField coalesceStrings(List values) =>
      _buildCollectionStringValuesFunction('COALESCE', values);

  /// Create sql statement with function `COALESCE()` function applied for several values,
  /// values may be [int] - [double] - [NumField] - [IntField] - [DoubleField].
  ///
  /// `COALESCE()` is used to get first not null value of [values], if all values are null,
  /// it returns null.
  static DoubleField coalesceNums(List values) =>
      _buildCollectionNumValuesFunction('COALESCE', values);

  /// Create sql statement with function `IFNULL()` function applied for two [QueryPart]s,
  ///
  /// `IFNULL()` is used to get first not null value of [x] and [y], if two values are null,
  /// it returns null.
  static QueryPart ifNull(QueryPart x, QueryPart y) {
    var result = QueryPart._();
    result.queryBuilder = () => 'IFNULL(${x.buildQuery()},${y.buildQuery()})';
    result.parametersBuilder =
        () => [...x.getParameters(), ...y.getParameters()];
    return result;
  }

  /// Create sql statement with function `DISTINCT()` function applied.
  /// `DISTINCT()` is used to get rows without duplicates of [fields] values.
  static QueryPart distinct(List<FieldWithValue> fields) {
    assert(fields.length > 0);
    QueryPart result = new QueryPart._();
    String qText = 'DISTINCT ';
    fields.forEach((element) {
      qText += element.buildQuery() + ',';
    });
    qText = qText.substring(0, qText.length - 1);
    qText += ' ';
    result.queryBuilder = () => qText;
    result.parametersBuilder =
        () => [for (var f in fields) ...f.getParameters()];
    return result;
  }

  static DateTimeField _buildCollectionDateTimesValuesFunction(
    String functionName,
    List values,
  ) {
    assertDateTimesValues(values);
    DateTimeField result = DateTimeField();
    result.queryBuilder =
        () => '$functionName(' + _buildListQuery(values) + ')';
    result.parametersBuilder = () => _buildParametersList(values);
    return result;
  }

  /// Assert each entry of [values] is a [DateTime] or [DateTimeField].
  static void assertDateTimesValues(List values) {
    assertNotNullValues(values);
    for (var v in values) {
      assert(v is DateTime || v is DateTimeField);
    }
  }

  /// Assert each entry of [values] is a [DateTime] or [DateTimeStringField].
  static void assertDateTimeStringsValues(List values) {
    assertNotNullValues(values);
    for (var v in values) {
      assert(v is DateTime || v is DateTimeStringField);
    }
  }

  /// Get [IntField] object with the sqlite version.
  static IntField get sqliteVersion {
    IntField result = IntField();
    result.queryBuilder = () => 'sqlite_version()';
    return result;
  }

  /// Get [StringField] object with the sqlite source id.
  static StringField get sqliteSourceId {
    StringField result = StringField();
    result.queryBuilder = () => 'sqlite_source_id()';
    return result;
  }

  /// Apply `MAX()` function for two db dates.
  static DateTimeField maxDatetimes(DateTimeField a, DateTimeField b) =>
      _buildCollectionDateTimesValuesFunction('MAX', [a, b]);

  /// Create sql statement with function `COALESCE()` function applied for several values,
  /// values may be [DateTime] - [DateTimeField].
  ///
  /// `COALESCE()` is used to get first not null value of [values], if all values are null,
  /// it returns null.
  static DateTimeField coalesceDateTimes(List values) =>
      _buildCollectionDateTimesValuesFunction('COALESCE', values);

  // static QueryPart iif(ConditionQuery condition, QueryPart x, QueryPart y) {
  //   var result = QueryPart();
  //   result.queryBuilder = () =>
  //       'IIF(${condition.buildQuery()}, ${x.buildQuery()},${y.buildQuery()})';
  //   result.parametersBuilder = () => [
  //         ...condition.getParameters(),
  //         ...x.getParameters(),
  //         ...y.getParameters()
  //       ];
  //   return result;
  // }
}
