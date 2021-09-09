part of '../../quds_db.dart';

/// Represents a db field -with its value if required-.
class FieldWithValue<T> extends QueryPart<T> {
  /// The column name of this field.
  final String? columnName;

  /// Represents the json part name of this value,
  /// needed for serialization (not for saving in db).
  final String? jsonMapName;

  /// The serialization type of this value.
  final Type? jsonMapType;

  /// The table name of this field.
  String? _tableName;

  /// Weather to add `NOT NULL` constraint.
  final bool? notNull;

  /// Weather to add `UNIQUE` constraint.
  final bool? isUnique;

  /// The field value in native dart.
  T? value;

  /// Get the field value in db storable tyle.
  get dbValue => DbHelper.getDbValue(value);

  /// Set the field value in db storable tyle.
  set dbValue(dynamic dbValue) =>
      value = DbHelper.getValueFromDbValue(T, dbValue);

  /// Create an instance of [FieldWithValue]
  FieldWithValue(this.columnName,
      {this.notNull,
      this.isUnique,
      T? defaultValue,
      this.jsonMapName,
      this.jsonMapType})
      : super._() {
    value = defaultValue;
  }

  /// Get the native dart type of this field value.
  Type get valueType => T;

  @override
  String buildQuery() {
    if (queryBuilder != null) return queryBuilder!();
    return (_tableName == null
            ? columnName
            : _tableName! + '.' + columnName!) ??
        '';
  }

  /// Get this field column definition for creation table.
  ///
  /// For example:
  ///
  /// `firstName TEXT NOT NULL`
  ///
  /// `serverId INT UNIQUE`
  String get columnDefinition {
    String result = '$columnName ${DbHelper._getFieldTypeAffinity(valueType)}';
    if (notNull == true) result += ' NOT NULL';
    if (isUnique == true) result += ' UNIQUE';
    return result;
  }

  @override
  List getParameters() => parametersBuilder != null ? parametersBuilder!() : [];

  /// Get sql statement to check weather this field value equal to another (db field, some native value).
  ConditionQuery equals(dynamic other) {
    return ConditionQuery(operatorString: '=', before: this, after: other);
  }

  /// Get sql statement to check weather this field value not equal to another (db field, some native value).
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

  /// Get sql statement to check weather this field value is in a collection of values.
  ///
  /// For example:
  ///
  /// ```dart
  /// where: (q) => q.firstName.toLowerCase().inCollection(['mohammed','ahmed'])
  /// ```
  ConditionQuery inCollection(List<T> collection) =>
      _buildInOrNotInCollection(collection, true);

  /// Get sql statement to check weather this field value is not in a collection of values.
  ///
  /// For example:
  ///
  /// ```dart
  /// where: (q) => q.firstName.toLowerCase().notInCollection(['mohammed','ahmed'])
  /// ```
  ConditionQuery notInCollection(List<T> collection) =>
      _buildInOrNotInCollection(collection, false);

  /// Get sql statement to check weather this field value is db null.
  ///
  /// For example:
  ///
  /// ```dart
  /// where: (q) => q.firstName.isNull
  /// ```
  ConditionQuery get isNull {
    var result = ConditionQuery();
    result.queryBuilder = () => '${this.buildQuery()} IS NULL';
    result.parametersBuilder = () => [];
    return result;
  }

  /// Get sql statement to check weather this field value is not db null.
  ///
  /// For example:
  ///
  /// ```dart
  /// where: (q) => q.firstName.isNotNull
  /// ```
  ConditionQuery get isNotNull {
    var result = ConditionQuery();
    result.queryBuilder = () => '${this.buildQuery()} IS NOT NULL';
    result.parametersBuilder = () => [];
    return result;
  }

  /// Get sql statement to order records in ascending way.
  ///
  /// For example:
  ///
  /// ```dart
  /// order: (q) => [q.firstName.ascOrder]
  /// ```
  FieldOrder get ascOrder {
    var result = FieldOrder();
    result.queryBuilder = () => this.buildQuery() + ' ASC';
    return result;
  }

  /// Get sql statement to order records in descending way.
  ///
  /// For example:
  ///
  /// ```dart
  /// order: (q) => [q.firstName.descOrder]
  /// ```
  FieldOrder get descOrder {
    var result = FieldOrder();
    result.queryBuilder = () => this.buildQuery() + ' DESC';
    return result;
  }

  /// Get sql statement to order records in random way.
  ///
  /// For example:
  ///
  /// ```dart
  /// order: (q) => [q.firstName.randomOrder]
  /// ```
  FieldOrder get randomOrder {
    var result = FieldOrder();
    result.queryBuilder = () => 'RANDOM()';
    return result;
  }

  /// Get an [IntField] with count of this field values.
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
}
