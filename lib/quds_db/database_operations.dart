part of '../quds_db.dart';

extension _DatabaseOperations on sqlite.Database {
  Future<int?> insert(String tableName, Map<String, dynamic> map) async {
    return insertSync(tableName, map);
  }

  int? insertSync(String tableName, Map<String, dynamic> map) {
    assert(map.isNotEmpty);
    var lid = lastInsertRowId;

    var vNames = '';
    var vValues = '';

    for (var k in map.keys) {
      vNames += '$k,';
      vValues += '?,';
    }
    vNames = vNames.substring(0, vNames.length - 1);
    vValues = vValues.substring(0, vValues.length - 1);
    select('INSERT INTO $tableName ($vNames) VALUES ($vValues) ',
        map.values.toList());

    return lastInsertRowId == 0 || lastInsertRowId == lid
        ? null
        : lastInsertRowId;
  }

  List<int?>? insertBuilkSync(
      String tableName, List<Map<String, dynamic>> mapsList) {
    assert(mapsList.isNotEmpty);
    var result = <int>[];
    execute('BEGIN TRANSACTION');
    for (var m in mapsList) {
      assert(m.isNotEmpty);
      var vNames = '';
      var vValues = '';
      for (var k in m.keys) {
        vNames += '$k,';
        vValues += '?,';
      }
      vNames = vNames.substring(0, vNames.length - 1);
      vValues = vValues.substring(0, vValues.length - 1);
      select('INSERT INTO [$tableName] ($vNames) VALUES ($vValues)',
          m.values.toList());
      result.add(lastInsertRowId);
    }
    execute('COMMIT');
    return result;
  }

  Future<List<int?>?> insertBuilk(
      String tableName, List<Map<String, dynamic>> mapsList) async {
    return insertBuilkSync(tableName, mapsList);
  }

  Future<void> update(String tableName, Map<String, dynamic> map,
      {String? where, List? whereArgs}) async {
    return updateSync(tableName, map, where: where, whereArgs: whereArgs);
  }

  void updateSync(String tableName, Map<String, dynamic> map,
      {String? where, List? whereArgs}) {
    assert(map.isNotEmpty);
    assert(whereArgs == null || where != null);

    var vValues = '';

    for (var k in map.keys) {
      vValues += '$k=?,';
    }
    vValues = vValues.substring(0, vValues.length - 1);
    var args = map.values.toList();
    if (whereArgs != null) args.addAll(whereArgs);

    execute(
        'UPDATE $tableName SET $vValues ' +
            (where == null ? '' : 'WHERE $where'),
        args);
  }

  Future<int> delete(String tableName, {String? where, List? whereArgs}) async {
    return deleteSync(tableName, where: where, whereArgs: whereArgs);
  }

  int deleteSync(String tableName, {String? where, List? whereArgs}) {
    assert(whereArgs == null || where != null);

    var args = [];
    if (whereArgs != null) args.addAll(whereArgs);

    try {
      execute(
          'DELETE FROM $tableName ' + (where == null ? '' : ' WHERE $where'),
          args);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  List<int?>? updateBulkSync(
      String tableName,
      List<Map<String, dynamic>> mapsList,
      List<String?> wheres,
      List<List?> wheresArgs) {
    assert(mapsList.isNotEmpty);
    var result = <int>[];
    execute('BEGIN TRANSACTION');
    for (int i = 0; i < mapsList.length; i++) {
      var m = mapsList[i];
      assert(m.isNotEmpty);
      List args = m.values.toList();
      var vValues = '';
      for (var k in m.keys) {
        vValues += '$k=?,';
      }
      vValues = vValues.substring(0, vValues.length - 1);
      var statement = 'UPDATE $tableName SET  $vValues';
      var where = wheres[i];
      var whereArgs = wheresArgs[i];
      if (where != null) {
        statement += ' $where';
        args.addAll(whereArgs ?? []);
      }
      select(statement, args);
      result.add(lastInsertRowId);
    }
    execute('COMMIT');
    return result;
  }

  Future<List<int?>?> updateBulk(
      String tableName,
      List<Map<String, dynamic>> mapsList,
      List<String?> wheres,
      List<List?> wheresArgs) async {
    return updateBulkSync(tableName, mapsList, wheres, wheresArgs);
  }
}
