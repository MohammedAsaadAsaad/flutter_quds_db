// part of '../quds_db.dart';

// var _writeLocks = Map<sqlite.Database, synch.Lock>();

// extension _DatabaseOperations on sqlite.Database {
//   synch.Lock get _writeLock {
//     return _writeLocks[this] ??= synch.Lock();
//   }

//   Future<int?> insert(String tableName, Map<String, dynamic> map) async {
//     final lock = _writeLock;
//     return lock.synchronized<int?>(() async {
//       return await _insertSync(tableName, map);
//     });
//   }

//   Future<int?> _insertSync(String tableName, Map<String, dynamic> map) async {
//     assert(map.isNotEmpty);
//     var lid = lastInsertRowId;

//     var vNames = '';
//     var vValues = '';

//     for (var k in map.keys) {
//       vNames += '$k,';
//       vValues += '?,';
//     }
//     vNames = vNames.substring(0, vNames.length - 1);
//     vValues = vValues.substring(0, vValues.length - 1);
//     select('INSERT INTO $tableName ($vNames) VALUES ($vValues) ',
//         map.values.toList());

//     return lastInsertRowId == 0 || lastInsertRowId == lid
//         ? null
//         : lastInsertRowId;
//   }

//   Future<List<int?>?> _insertBuilkSync(
//       String tableName, List<Map<String, dynamic>> mapsList) async {
//     assert(mapsList.isNotEmpty);
//     var result = <int>[];
//     execute('BEGIN TRANSACTION');
//     for (var m in mapsList) {
//       assert(m.isNotEmpty);
//       var vNames = '';
//       var vValues = '';
//       for (var k in m.keys) {
//         vNames += '$k,';
//         vValues += '?,';
//       }
//       vNames = vNames.substring(0, vNames.length - 1);
//       vValues = vValues.substring(0, vValues.length - 1);
//       select('INSERT INTO [$tableName] ($vNames) VALUES ($vValues)',
//           m.values.toList());
//       result.add(lastInsertRowId);
//     }
//     execute('COMMIT');
//     return result;
//   }

//   Future<List<int?>?> insertBuilk(
//       String tableName, List<Map<String, dynamic>> mapsList) async {
//     final lock = _writeLock;
//     return lock.synchronized<List<int?>?>(() async {
//       return await _insertBuilkSync(tableName, mapsList);
//     });
//   }

//   Future<void> update(String tableName, Map<String, dynamic> map,
//       {String? where, List? whereArgs}) async {
//     final lock = _writeLock;
//     return lock.synchronized<void>(() async {
//       await _updateSync(tableName, map, where: where, whereArgs: whereArgs);
//     });
//   }

//   Future<void> _updateSync(String tableName, Map<String, dynamic> map,
//       {String? where, List? whereArgs}) async {
//     assert(map.isNotEmpty);
//     assert(whereArgs == null || where != null);

//     var vValues = '';

//     for (var k in map.keys) {
//       vValues += '$k=?,';
//     }
//     vValues = vValues.substring(0, vValues.length - 1);
//     var args = map.values.toList();
//     if (whereArgs != null) args.addAll(whereArgs);

//     execute(
//         'UPDATE $tableName SET $vValues ' +
//             (where == null ? '' : 'WHERE $where'),
//         args);
//   }

//   Future<int> delete(String tableName, {String? where, List? whereArgs}) async {
//     final lock = _writeLock;
//     return lock.synchronized<int>(() async {
//       return await _deleteSync(tableName, where: where, whereArgs: whereArgs);
//     });
//   }

//   Future<int> _deleteSync(String tableName,
//       {String? where, List? whereArgs}) async {
//     assert(whereArgs == null || where != null);

//     var args = [];
//     if (whereArgs != null) args.addAll(whereArgs);

//     try {
//       execute(
//           'DELETE FROM $tableName ' + (where == null ? '' : ' WHERE $where'),
//           args);
//       return 1;
//     } catch (e) {
//       return 0;
//     }
//   }

//   Future<List<int?>?> _updateBulkSync(
//       String tableName,
//       List<Map<String, dynamic>> mapsList,
//       List<String?> wheres,
//       List<List?> wheresArgs) async {
//     assert(mapsList.isNotEmpty);
//     var result = <int>[];
//     execute('BEGIN TRANSACTION');
//     for (int i = 0; i < mapsList.length; i++) {
//       var m = mapsList[i];
//       assert(m.isNotEmpty);
//       List args = m.values.toList();
//       var vValues = '';
//       for (var k in m.keys) {
//         vValues += '$k=?,';
//       }
//       vValues = vValues.substring(0, vValues.length - 1);
//       var statement = 'UPDATE $tableName SET  $vValues';
//       var where = wheres[i];
//       var whereArgs = wheresArgs[i];
//       if (where != null) {
//         statement += ' $where';
//         args.addAll(whereArgs ?? []);
//       }
//       select(statement, args);
//       result.add(lastInsertRowId);
//     }
//     execute('COMMIT');
//     return result;
//   }

//   Future<List<int?>?> updateBulk(
//       String tableName,
//       List<Map<String, dynamic>> mapsList,
//       List<String?> wheres,
//       List<List?> wheresArgs) async {
//     final lock = _writeLock;
//     return lock.synchronized<List<int?>?>(() async {
//       return await _updateBulkSync(tableName, mapsList, wheres, wheresArgs);
//     });
//   }
// }
