import '../../quds_db.dart';

class ConditionQuery<T> extends OperatorQuery<bool> {
  ConditionQuery({String? operatorString, QueryPart? before, dynamic? after})
      : super(operatorString, before, after);

  ConditionQuery operator &(ConditionQuery other) =>
      ConditionQuery(before: this, after: other, operatorString: 'AND');

  ConditionQuery operator |(ConditionQuery other) =>
      ConditionQuery(before: this, after: other, operatorString: 'OR');

  @override
  List getParameters() {
    if (parametersBuilder != null) return parametersBuilder!();
    return super.getParameters();
  }
}
