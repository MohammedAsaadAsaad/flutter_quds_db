import '../quds_db.dart';

class DbFunctions {
  static void assertNotNullValues(List values) => values.forEach((element) {
        assert(element != null);
      });
  static void assertNumValues(List values) {
    assertNotNullValues(values);
    for (var v in values) assert(v is num || v is NumField);
  }

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

  static DoubleField max(NumField f) =>
      _buildCollectionNumValuesFunction('MAX', [f]);
  static DoubleField min(NumField f) =>
      _buildCollectionNumValuesFunction('MIN', [f]);
  static DoubleField sum(List values) =>
      _buildCollectionNumValuesFunction('SUM', values);
  static DoubleField count(List values) =>
      _buildCollectionNumValuesFunction('COUNT', values);
  // static DoubleField avg(List values) =>
  //     _buildCollectionNumValuesFunction('AVG', values);

  static StringField concatGroup(List values) =>
      _buildCollectionStringValuesFunction('GROUP_CONCAT', values);

  static StringField coalesceStrings(List values) =>
      _buildCollectionStringValuesFunction('COALESCE', values);

  static DoubleField coalesceNums(List values) =>
      _buildCollectionNumValuesFunction('COALESCE', values);

  static QueryPart ifNull(QueryPart x, QueryPart y) {
    var result = QueryPart();
    result.queryBuilder = () => 'IFNULL(${x.buildQuery()},${y.buildQuery()})';
    result.parametersBuilder =
        () => [...x.getParameters(), ...y.getParameters()];
    return result;
  }

  static QueryPart distinct(List<FieldWithValue> fields) {
    assert(fields.length > 0);
    QueryPart result = new QueryPart();
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

  static void assertDateTimesValues(List values) {
    assertNotNullValues(values);
    for (var v in values) {
      assert(v is DateTime || v is DateTimeField);
    }
  }

  static void assertDateTimeStringsValues(List values) {
    assertNotNullValues(values);
    for (var v in values) {
      assert(v is DateTime || v is DateTimeStringField);
    }
  }

  static IntField get sqliteVersion {
    IntField result = IntField();
    result.queryBuilder = () => 'sqlite_version()';
    return result;
  }

  static StringField get sqliteSourceId {
    StringField result = StringField();
    result.queryBuilder = () => 'sqlite_source_id()';
    return result;
  }

  static DateTimeField maxDatetimes(DateTimeField a, DateTimeField b) =>
      _buildCollectionDateTimesValuesFunction('MAX', [a, b]);

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
