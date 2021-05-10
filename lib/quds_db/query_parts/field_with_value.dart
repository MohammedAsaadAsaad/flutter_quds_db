import 'package:flutter/painting.dart';

import '../../quds_db.dart';

class FieldWithValue<T> extends QueryPart<T> {
  final String? columnName;
  final String? jsonMapName;
  final Type? jsonMapType;

  String? tableName;
  final bool? notNull;
  final bool? isUnique;
  T? value;

  get dbValue => DbHelper.getDbValue(value);
  set dbValue(dynamic dbValue) =>
      value = DbHelper.getValueFromDbValue(T, dbValue);

  FieldWithValue(this.columnName,
      {this.notNull,
      this.isUnique,
      T? defaultValue,
      this.jsonMapName,
      this.jsonMapType}) {
    value = defaultValue;
  }

  Type get valueType => T;

  @override
  String buildQuery() {
    if (queryBuilder != null) return queryBuilder!();
    return (tableName == null ? columnName : tableName! + '.' + columnName!) ??
        '';
  }

  String get columnDefinition {
    String result = '$columnName ${DbHelper.getFieldTypeAffinity(T)}';
    if (notNull == true) result += ' NOT NULL';
    if (isUnique == true) result += ' UNIQUE';
    return result;
  }

  @override
  List getParameters() => parametersBuilder != null ? parametersBuilder!() : [];

  ConditionQuery equals(dynamic other) {
    return ConditionQuery(operatorString: '=', before: this, after: other);
  }

  ConditionQuery notEquals(dynamic other) {
    return ConditionQuery(operatorString: '!=', before: this, after: other);
  }

  ConditionQuery _buildInOrNotInCollection(List<T> collection, bool inC) {
    var result = ConditionQuery();
    result.parametersBuilder = () => this.getParameters()..addAll(collection);
    String resultQuery = this.buildQuery() + ' ${inC ? 'IN' : 'NOT IN'} (';

    collection.forEach((element) => resultQuery += '?,');

    if (resultQuery.endsWith(','))
      resultQuery = resultQuery.substring(0, resultQuery.length - 1);
    resultQuery += ')';

    result.queryBuilder = () => resultQuery;
    return result;
  }

  ConditionQuery inCollection(List<T> collection) =>
      _buildInOrNotInCollection(collection, true);

  ConditionQuery notInCollection(List<T> collection) =>
      _buildInOrNotInCollection(collection, false);
  ConditionQuery get isNull {
    var result = ConditionQuery();
    result.queryBuilder = () => '${this.buildQuery()} IS NULL';
    result.parametersBuilder = () => [];
    return result;
  }

  ConditionQuery get isNotNull {
    var result = ConditionQuery();
    result.queryBuilder = () => '${this.buildQuery()} IS NOT NULL';
    result.parametersBuilder = () => [];
    return result;
  }

  OrderField get ascOrder {
    var result = OrderField();
    result.queryBuilder = () => this.buildQuery() + ' ASC';
    return result;
  }

  OrderField get descOrder {
    var result = OrderField();
    result.queryBuilder = () => this.buildQuery() + ' DESC';
    return result;
  }

  OrderField get randomOrder {
    var result = OrderField();
    result.queryBuilder = () => 'RANDOM()';
    return result;
  }

  IntField count() {
    IntField result = IntField();
    result.queryBuilder = () => 'COUNT(${this.buildQuery()})';
    result.parametersBuilder = () => [...this.getParameters()];
    return result;
  }

  @override
  String toString() {
    return '$value';
  }

  static getValueFromDbValue(Type type, dynamic dbValue) {
    if (type == bool) return dbValue == null ? null : dbValue == 1;

    if (type == DateTime)
      return dbValue == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(dbValue);

    if (type == Color) return dbValue == null ? null : Color(dbValue);

    return dbValue;
  }

  static getDbValue(dynamic value) {
    var type = value.runtimeType;
    if (type == bool)
      return value == null
          ? null
          : value
              ? 1
              : 0;

    if (type == DateTime)
      return value == null ? null : value.millisecondsSinceEpoch;

    if (type == Color) return value == null ? null : (value as Color).value;

    return value;
  }
}
