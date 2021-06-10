part of '../quds_db.dart';

/// Provide some helping methods for managing the database.
class DbHelper {
  /// To prevent creating instances of [DbHelper].
  DbHelper._();

// All disabled field types are not supported in web
  static Map<String, List<Type>> _fieldType = const {
    'TEXT': const [
      String,
    ],
    'INTEGER': const [
      Color,
      DateTime,
      int,
      // Int32,
      // Int16,
      // Int64,
      // Int8,
      // Uint16,
      // Uint32,
      // Uint64,
      // Uint8
    ],
    'BIT': const [
      bool,
    ],
    'REAL': const [
      double,
      // Float,
    ],
    'BLOB': const [Uint8List],
    'NUMERIC': const [num]
  };

  /// Get the db field type name of dart native type.
  static String _getFieldTypeAffinity(Type type) {
    return _fieldType.keys
        .firstWhere((element) => _fieldType[element]!.contains(type));
  }

  /// Get a sql statement to joint operand like (+, >) with another field or value.
  static String buildQueryForOperand(dynamic v) =>
      v is QueryPart ? v.buildQuery() : '?';

  /// The main db path where all tables to be saved untill one is customized.
  static String mainDbPath = 'data.db';

  static Map<Type, sqlite_api.Database> _createdTablesWindows = new Map();
  static Map<Type, sqflite.Database> _createdTablesCross = new Map();
  static Map<Type, dynamic> _createdTablesWeb = new Map();

  /// Check [DbTableProvider] 's table in the db and create or modify as required.
  static Future _checkDbAndTable(DbTableProvider dbProvider) async {
    var map = kIsWeb
        ? _createdTablesWeb
        : Platform.isWindows
            ? _createdTablesWindows
            : _createdTablesCross;

    if (map[dbProvider.runtimeType] != null) return map[dbProvider.runtimeType];

    String dbPath = (dbProvider._specialDbFile == null ||
            dbProvider._specialDbFile!.trim().isEmpty)
        ? DbHelper.mainDbPath
        : dbProvider._specialDbFile!;

    var database;
    // if (kIsWeb) {
    //   database = await _webSqlOpenDatabase(dbPath);
    // } else
    if (Platform.isWindows) {
      database = await sqflite_ffi.databaseFactoryFfi.openDatabase(dbPath);
    } else {
      database = await sqflite.openDatabase(dbPath);
    }

    await _createTablesInDB(dbProvider, database);
    map[dbProvider.runtimeType] = database;
    return database;
  }

  /// Create [DbTableProvider] 's table in the db.
  static Future<bool> _createTablesInDB(
      DbTableProvider provider, dynamic db) async {
    try {
      await provider._checkAndCreateTableIfNotExist(db);
      await provider._checkEachColumn(db);
      return true;
    } catch (e) {
      return false;
    }
  }

  static dynamic _getMapValue(dynamic value, Type returnType) {
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

  /// Get dart native value of some db value.
  static getValueFromDbValue(Type type, dynamic dbValue) {
    if (type == bool) return dbValue == null ? null : dbValue == 1;

    if (type == DateTime)
      return dbValue == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(dbValue);

    if (type == Color) return dbValue == null ? null : Color(dbValue);

    return dbValue;
  }

  /// Get db value of some dart native value.
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

    if (type == Color) return value == null ? null : (value as Color).value;

    return value;
  }
}
