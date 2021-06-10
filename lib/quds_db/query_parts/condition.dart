part of '../../quds_db.dart';

/// Represents a sql condition statement like
///
/// 'age > 5'
///
/// 'SUBSTR(firstName,1,6) CONTAINS ...'
class ConditionQuery<T> extends OperatorQuery<bool> {
  /// Create an instance of [ConditionQuery]
  ConditionQuery({String? operatorString, QueryPart? before, dynamic after})
      : super(operatorString, before, after);

  /// Join two sql condition statements with 'AND'
  ConditionQuery operator &(ConditionQuery other) =>
      ConditionQuery(before: this, after: other, operatorString: 'AND');

  /// Join two sql condition statements with 'OR'
  ConditionQuery operator |(ConditionQuery other) =>
      ConditionQuery(before: this, after: other, operatorString: 'OR');

  @override
  List getParameters() {
    if (parametersBuilder != null) return parametersBuilder!();
    return super.getParameters();
  }
}
