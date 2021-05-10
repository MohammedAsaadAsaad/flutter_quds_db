import '../../quds_db.dart';

class OperatorQuery<T> extends QueryPart {
  final String? operatorText;
  dynamic? before;
  dynamic? after;

  OperatorQuery(this.operatorText, this.before, this.after);

  @override
  String buildQuery() {
    if (this.queryBuilder != null) return this.queryBuilder!();
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
