part of 'support_functions.dart';

void _addMathSupportFunctions(Database db) {
  db.createFunction(
      functionName: 'sin',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.sin(arg);
      });

  db.createFunction(
      functionName: 'cos',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.cos(arg);
      });

  db.createFunction(
      functionName: 'tan',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.tan(arg);
      });

  db.createFunction(
      functionName: 'degrees',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg * 180.0 / math.pi;
      });

  db.createFunction(
      functionName: 'radians',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg * math.pi / 180.0;
      });

  db.createFunction(
      functionName: 'pi',
      argumentCount: AllowedArgumentCount(0),
      function: (s) {
        return math.pi;
      });

  db.createFunction(
      functionName: 'exp',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.exp(arg);
      });

  db.createFunction(
      functionName: 'asin',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.asin(arg);
      });

  db.createFunction(
      functionName: 'acos',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.acos(arg);
      });

  db.createFunction(
      functionName: 'atan',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.atan(arg);
      });

  db.createFunction(
      functionName: 'atan2',
      argumentCount: AllowedArgumentCount(2),
      function: (s) {
        var arg1 = s[0] as num;
        var arg2 = s[1] as num;
        return math.atan2(arg1, arg2);
      });

  db.createFunction(
      functionName: 'floor',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.floor();
      });

  db.createFunction(
      functionName: 'ln',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg);
      });

  db.createFunction(
      functionName: 'log',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg) / math.ln10;
      });

  db.createFunction(
      functionName: 'log10',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg) / math.ln10;
      });

  db.createFunction(
      functionName: 'log2',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg) / math.ln2;
      });

  db.createFunction(
      functionName: 'log_b',
      argumentCount: AllowedArgumentCount(2),
      function: (s) {
        var b = s[0] as num;
        var arg = s[1] as num;
        return math.log(arg) / math.log(b);
      });

  db.createFunction(
      functionName: 'pow',
      argumentCount: AllowedArgumentCount(2),
      function: (s) {
        var x = s[0] as num;
        var y = s[1] as num;
        return math.pow(x, y);
      });

  db.createFunction(
      functionName: 'power',
      argumentCount: AllowedArgumentCount(2),
      function: (s) {
        var x = s[0] as num;
        var y = s[1] as num;
        return math.pow(x, y);
      });

  db.createFunction(
      functionName: 'ceil',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.ceil();
      });

  db.createFunction(
      functionName: 'ceiling',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.ceil();
      });

  db.createFunction(
      functionName: 'sqrt',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.sqrt(arg);
      });
}
