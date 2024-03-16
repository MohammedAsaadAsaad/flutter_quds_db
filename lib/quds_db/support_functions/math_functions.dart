part of 'support_functions.dart';

void _addMathSupportFunctions(Database db) {
  db.createFunction(
      functionName: 'sin',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.sin(arg);
      });

  db.createFunction(
      functionName: 'cos',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.cos(arg);
      });

  db.createFunction(
      functionName: 'tan',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.tan(arg);
      });

  db.createFunction(
      functionName: 'degrees',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg * 180.0 / math.pi;
      });

  db.createFunction(
      functionName: 'radians',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg * math.pi / 180.0;
      });

  db.createFunction(
      functionName: 'pi',
      argumentCount: const AllowedArgumentCount(0),
      function: (s) {
        return math.pi;
      });

  db.createFunction(
      functionName: 'exp',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.exp(arg);
      });

  db.createFunction(
      functionName: 'asin',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.asin(arg);
      });

  db.createFunction(
      functionName: 'acos',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.acos(arg);
      });

  db.createFunction(
      functionName: 'atan',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.atan(arg);
      });

  db.createFunction(
      functionName: 'atan2',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var arg1 = s[0] as num;
        var arg2 = s[1] as num;
        return math.atan2(arg1, arg2);
      });

  db.createFunction(
      functionName: 'floor',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.floor();
      });

  db.createFunction(
      functionName: 'ln',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg);
      });

  db.createFunction(
      functionName: 'log',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg) / math.ln10;
      });

  db.createFunction(
      functionName: 'log10',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg) / math.ln10;
      });

  db.createFunction(
      functionName: 'log2',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.log(arg) / math.ln2;
      });

  db.createFunction(
      functionName: 'log_b',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var b = s[0] as num;
        var arg = s[1] as num;
        return math.log(arg) / math.log(b);
      });

  db.createFunction(
      functionName: 'pow',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var x = s[0] as num;
        var y = s[1] as num;
        return math.pow(x, y);
      });

  db.createFunction(
      functionName: 'power',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var x = s[0] as num;
        var y = s[1] as num;
        return math.pow(x, y);
      });

  db.createFunction(
      functionName: 'ceil',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.ceil();
      });

  db.createFunction(
      functionName: 'ceiling',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.ceil();
      });

  db.createFunction(
      functionName: 'sqrt',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return math.sqrt(arg);
      });

  db.createFunction(
      functionName: 'abs',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as num;
        return arg.abs();
      });
}
