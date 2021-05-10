import '../../quds_db.dart';

class QueryPart<T> {
  String buildQuery() => queryBuilder == null ? '' : queryBuilder!();
  List<dynamic> getParameters() {
    if (parametersBuilder != null) return parametersBuilder!();
    return [];
  }

  String Function()? queryBuilder;

  List<dynamic> Function()? parametersBuilder;

  QueryPart asNamed(String name) {
    var result = QueryPart();
    result.queryBuilder = () => this.buildQuery() + ' AS \'$name\'';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  StringField typeof() {
    StringField result = StringField();
    result.queryBuilder = () => 'TYPEOF(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }
}
