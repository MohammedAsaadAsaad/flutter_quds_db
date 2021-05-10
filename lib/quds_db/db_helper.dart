import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:sqflite_common/sqlite_api.dart' as sqlite_api;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import '../quds_db.dart';

class DbHelper {
  static Map<String, List<Type>> _fieldType = {
    'TEXT': [
      String,
    ],
    'INTEGER': [
      // Color,
      DateTime,
      int,
      Int32,
      Int16,
      Int64,
      Int8,
      Uint16,
      Uint32,
      Uint64,
      Uint8
    ],
    'BIT': [
      bool,
    ],
    'REAL': [
      double,
      Float,
    ],
    'BLOB': [Uint8List],
    'NUMERIC': [num]
  };

  static String getFieldTypeAffinity(Type type) {
    return _fieldType.keys
        .firstWhere((element) => _fieldType[element]!.contains(type));
  }

  static getValueFromDbValue(Type type, dynamic dbValue) {
    if (type == bool) return dbValue == null ? null : dbValue == 1;

    if (type == DateTime)
      return dbValue == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(dbValue);

    // if  (type == Color) return dbValue == null ? null : Color(dbValue);

    return dbValue;
  }

  static getDbValue(dynamic value) {
    var type = value.runtimeType;
    if (type == bool)
      return value == null
          ? null
          : value
              ? 1
              : 0;

    if (type == DateTime)
      return value == null ? null : value.millisecondsSinceEpoch;

    // if (type == Color) return value == null ? null : (value as Color).value;

    return value;
  }

  static String buildQueryForOperand(dynamic v) =>
      v is QueryPart ? v.buildQuery() : '?';

  static String mainDbPath = 'data.db';

  static Map<Type, sqlite_api.Database> _createdTablesWindows = new Map();
  static Map<Type, sqflite.Database> _createdTablesCross = new Map();

  static Future checkDbAndTable(DbTableProvider dbProvider) async {
    var map = Platform.isWindows ? _createdTablesWindows : _createdTablesCross;
    if (map[dbProvider.runtimeType] != null) return map[dbProvider.runtimeType];

    String dbPath = (dbProvider.specialDbFile == null ||
            dbProvider.specialDbFile!.trim().isEmpty)
        ? DbHelper.mainDbPath
        : dbProvider.specialDbFile!;

    var database = Platform.isWindows
        ? await sqflite_ffi.databaseFactoryFfi.openDatabase(dbPath)
        : await sqflite.openDatabase(dbPath);
    await _createTablesInDB(dbProvider, database);
    map[dbProvider.runtimeType] = database;
    return database;
  }

  static Future<bool> _createTablesInDB(
      DbTableProvider provider, dynamic db) async {
    try {
      await provider.checkAndCreateTableIfNotExist(db);
      await provider.checkEachColumn(db);
      return true;
    } catch (e) {
      return false;
    }
  }

  static dynamic getMapValue(dynamic value, Type returnType) {
    switch (returnType) {
      case int:
        return value is int
            ? value
            : value == null
                ? null
                : int.tryParse(value.toString());
      case double:
        return value is double
            ? value
            : value == null
                ? null
                : double.tryParse(value.toString());
      case num:
        return value is num
            ? value
            : value == null
                ? null
                : num.tryParse(value.toString());
      case DateTime:
        return value is DateTime
            ? value
            : value == null
                ? null
                : DateTime.tryParse(value.toString());
      case bool:
        return value is bool
            ? value
            : value == null
                ? null
                : ['true', '1'].contains(value.toString().toLowerCase().trim());
      case String:
        return value is String
            ? value
            : value == null
                ? null
                : value.toString();

      case Color:
        return value is Color
            ? value
            : value == null
                ? null
                : value is int
                    ? Color(value)
                    : value is String
                        ? Color(int.parse(value.toString()))
                        : null;
    }
    return null;
  }

  static dynamic setMapValue(String jsonMapName, [Type? jsonMapType]) {}
}
