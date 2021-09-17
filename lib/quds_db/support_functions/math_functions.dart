part of 'support_functions.dart';

void _addMathSupportFunctions(Database db) {
  db.createFunction(
      functionName: 'atan',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.atan(arg);
      });
  db.createFunction(
      functionName: 'sin',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.sin(arg);
      });
}
