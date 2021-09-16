part of '../quds_db.dart';

/// Provide some helping methods for managing the database.
class DbHelper {
  /// To prevent creating instances of [DbHelper].
  DbHelper._();

  static Map<String, List<Type>> _fieldType = const {
    'TEXT': const [String, Map, List, Object],
    'INTEGER': const [
      Color,
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
  static String? mainDbPath;

  static Map<String, sqflite_api.Database> _createdTables = new Map();

  static bool _initialized = false;
  static Future<void> _initializeDb() async {
    if (_initialized) return;
    mainDbPath = (await path_provider.getApplicationSupportDirectory()).path +
        '/data.db';
    _initialized = true;

    if (kDebugMode) {
      log('_______________Quds Db________________');
      log('Hi great developer!');
      log('Would you donate to Quds Db developers team?\nIt will be great help to our team to continue the developement!');
      log('_____________Donation Link____________');
      log('https://www.paypal.com/donate?hosted_button_id=94Y2Q9LQR9XHS');
    }
  }

  /// Check [DbTableProvider] 's table in the db and create or modify as required.
  static Future _checkDbAndTable(DbTableProvider dbProvider) async {
    await _initializeDb();
    var map = _createdTables;

    String dbPath = (dbProvider._specialDbFile == null ||
            dbProvider._specialDbFile!.trim().isEmpty)
        ? DbHelper.mainDbPath!
        : dbProvider._specialDbFile!;
    String mapKey = dbPath + '.' + dbProvider.tableName;

    if (map[mapKey] != null) return map[mapKey];

    var database = await sqflite_ffi.databaseFactoryFfi.openDatabase(dbPath);
    // await _initializeSupportDbFunction(database);

    await _createTablesInDB(dbProvider, database);
    map[mapKey] = database;
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

      case Map:
        return value is Map
            ? value
            : value == null
                ? null
                : value is String
                    ? json.decode(value)
                    : null;

      case List:
        return value is List
            ? value
            : value == null
                ? null
                : value is String
                    ? json.decode(value)
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
    if (type == Map) return dbValue == null ? null : json.decode(dbValue);
    if (type == List) return dbValue == null ? null : json.decode(dbValue);
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

    if (value is Map) return json.encode(value);
    if (value is List) return json.encode(value);

    return value;
  }

  // static Future<void> _initializeSupportDbFunction(
  //     sqflite_api.Database db) async {
  //   // db.createAggregateFunction(
  //   //     functionName: 'test_function', function: ATanFunction());
  // }
}
