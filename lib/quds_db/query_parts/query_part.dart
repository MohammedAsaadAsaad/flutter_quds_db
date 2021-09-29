part of '../../quds_db.dart';

/// Represents any type of sql statements.
class QueryPart<T> {
  /// Create an internal instance of [QueryPart]
  QueryPart._();

  /// Get the sql text represents this [QueryPart]
  String buildQuery() => queryBuilder == null ? '' : queryBuilder!();

  /// Get the parameters of this [QueryPart],
  ///
  /// for example:
  ///
  /// [IntField] has its int value as parameter.
  ///
  /// [FieldWithValue.inCollection] has list of values as parameters.
  List<dynamic> getParameters() {
    if (parametersBuilder != null) return parametersBuilder!();
    return [];
  }

  /// Build the sql query of this [QueryPart].
  String Function()? queryBuilder;

  /// Build the sql query of this [QueryPart] parameters.
  List<dynamic> Function()? parametersBuilder;

  /// Get [QueryPart] with custom name.
  ///
  /// Usually used for simplifying query names.
  ///
  /// For example:
  ///
  /// ```dart
  /// personsProvider.query(queries:(p)=>[p.firstName.toLowerCase().asNamed('lname'),n.age])
  /// ```
  /// This results db table as:
  ///
  /// |lname|age|
  ///
  /// |mohammed|15|
  ///
  /// |ahmed|12|
  QueryPart asNamed(String name) {
    var result = QueryPart._();
    result.queryBuilder = () => buildQuery() + ' AS \'$name\'';
    result.parametersBuilder = () => getParameters();
    return result;
  }

  /// Get the db type of this query part using `TYPEOF()` function.
  StringField typeof() {
    StringField result = StringField();
    result.queryBuilder = () => 'TYPEOF(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }
}
