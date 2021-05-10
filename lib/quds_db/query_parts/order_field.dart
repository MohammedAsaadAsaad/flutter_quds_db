import 'query_part.dart';

class OrderField extends QueryPart {
  @override
  String buildQuery() {
    if (queryBuilder != null) return queryBuilder!();
    return '';
  }
}
