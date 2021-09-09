part of '../../quds_db.dart';

/// Represents sql order part.
///
/// for example: `ASC` `DESC` `RANDOM()`
class FieldOrder extends QueryPart {
  /// Create an instance of [FieldOrder]
  FieldOrder() : super._();
  @override
  String buildQuery() {
    if (queryBuilder != null) return queryBuilder!();
    return '';
  }
}
