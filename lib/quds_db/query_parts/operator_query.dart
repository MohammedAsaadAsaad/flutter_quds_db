part of '../../quds_db.dart';

/// Represents a binary operator with two operands statement.
class OperatorQuery<T> extends QueryPart {
  /// The operator text, for example:
  ///
  /// `<` `>` `AND` `=`
  final String? operatorText;

  /// The left operand.
  ///
  /// [before] may be any query part or of any dart native type.
  dynamic before;

  /// The right operand.
  ///
  /// [after] may be any query part or of any dart native type.
  dynamic after;

  /// Create an instance of [OperatorQuery]
  OperatorQuery(this.operatorText, this.before, this.after) : super._();

  @override
  String buildQuery() {
    if (queryBuilder != null) return queryBuilder!();
    return operatorText == null
        ? ''
        : "(" +
            _buildQueryForOperand(before) +
            ' ' +
            operatorText! +
            ' ' +
            _buildQueryForOperand(after) +
            ")";
  }

  String _buildQueryForOperand(dynamic v) =>
      v is QueryPart ? v.buildQuery() : '?';

  @override
  List getParameters() {
    var beforeParameters = [
      if (before is QueryPart)
        ...before.getParameters()
      else
        DbHelper.getDbValue(before),
    ];

    var afterParameters = [
      if (after is QueryPart)
        ...after.getParameters()
      else
        DbHelper.getDbValue(after),
    ];

    var result = [...beforeParameters, ...afterParameters];
    return result;
  }
}
