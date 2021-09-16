// import 'dart:math';

// import 'package:sqlite3/sqlite3.dart';

// class ATanFunction extends AggregateFunction<double> {
//   @override
//   AggregateContext<double> createContext() {
//     return AggregateContext(0);
//   }

//   @override
//   Object? finalize(AggregateContext<double> context) {}

//   @override
//   void step(List<Object?> arguments, AggregateContext<double> context) {
//     print(arguments);
//     context.value = atan(arguments[0] as double);
//   }
// }
