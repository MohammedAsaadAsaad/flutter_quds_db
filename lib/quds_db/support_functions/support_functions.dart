import 'dart:convert';
import 'dart:math' as math;
import 'package:sqlite3/sqlite3.dart';

part 'math_functions.dart';
part 'json_functions.dart';

void initializeSupportFunctions(Database db) {
  _addMathSupportFunctions(db);
  _addJsonFunctions(db);
}
