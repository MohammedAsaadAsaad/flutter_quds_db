import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite_common/sqlite_api.dart' as sqlite_api;
import 'package:sqflite/sqflite.dart' as sqflite;

import '../quds_db.dart';

abstract class DbTableProvider<T extends DbModel> {
  String? specialDbFile;

  String get tableName;
  String get idColumnName => 'id';

  String get createStatement {
    T tempEntry = _createInstance();

    String cS = 'CREATE TABLE IF NOT EXISTS ' + tableName;
    cS += '(';
    tempEntry.getAllFields().forEach((e) {
      cS += e!.columnDefinition + ',';
    });
    //Remove last ','
    cS = cS.substring(0, cS.length - 1);

    cS += ')';
    return cS;
  }

  sqlite_api.Database? databaseWindows;
  sqflite.Database? databaseCross;
  bool databaseInitialized = false;

  Future initializeDB() async {
    if (databaseInitialized)
      return Platform.isWindows ? databaseWindows : databaseCross;

    Platform.isWindows
        ? databaseWindows = await DbHelper.checkDbAndTable(this)
        : databaseCross = await DbHelper.checkDbAndTable(this);

    databaseInitialized = true;
    return Platform.isWindows ? databaseWindows : databaseCross;
  }

  Future<bool> closeDB() async {
    try {
      if (databaseInitialized /*&& database.isOpen*/)
        Platform.isWindows ? databaseWindows?.close() : databaseCross?.close();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkAndCreateTableIfNotExist(dynamic db) async {
    try {
      db.execute(createStatement);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future vaccumDb() async {
    var db = await initializeDB();
    await db.rawQuery('vacuum;');
  }

  Future<bool> checkEachColumn(dynamic db) async {
    var tableInfo = await db.rawQuery('PRAGMA table_info($tableName)');

    var foundColumns = new Map<String, String>();
    tableInfo.forEach((m) {
      var v = m.values.toList();
      foundColumns[v[1].toString().toLowerCase()] = v[2];
    });

    T tempEntry = _createInstance();
    var fields = tempEntry.getAllFields();
    for (var f in fields) {
      if (!foundColumns.containsKey(f!.columnName?.toLowerCase())) {
        //Missed key
        db.execute('ALTER TABLE $tableName\n'
            'ADD ${f.columnDefinition}');
      }
    }
    return true;
  }

//CRUD Methods
  Future<bool> insertEntry(T entry) async {
    try {
      await entry.beforeSave(true);

      int result = 0;
      var db = await initializeDB();
      var map = new Map<String, dynamic>();
      entry.creationTime.value = DateTime.now();
      entry.modificationTime.value = DateTime.now();
      _setEntryToMap(entry, map);
      result = await db.insert(tableName, map);
      entry.id.value = result;
      await entry.afterSave(true);
      _fireChangeListners(EntryChangeType.Insertion, entry);
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> insertCollection(List<T> items) async {
    if (items.length == 0) return;
    try {
      var db = await initializeDB();
      var batch = db.batch();
      for (var entry in items) {
        await entry.beforeSave(true);
        var map = new Map<String, dynamic>();
        entry.creationTime.value = DateTime.now();
        entry.modificationTime.value = DateTime.now();
        _setEntryToMap(entry, map);
        batch.insert(tableName, map);
        await entry.afterSave(true);
      }
      var result = await batch.commit();
      for (int i = 0; i < items.length; i++) {
        items[i].id.value = result[i];
        _fireChangeListners(EntryChangeType.Insertion, items[i]);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updateCollectionById(List<T> items) async {
    try {
      var db = await initializeDB();
      var batch = db.batch();
      for (var entry in items) {
        await entry.beforeSave(true);
        var map = new Map<String, dynamic>();
        entry.creationTime.value = DateTime.now();
        entry.modificationTime.value = DateTime.now();
        _setEntryToMap(entry, map);
        batch.update(tableName, map,
            where: '$idColumnName = ${entry.id.value}');
        await entry.afterSave(true);
      }
      await batch.commit();
      for (int i = 0; i < items.length; i++) {
        // items[i].id = result[i];
        _fireChangeListners(EntryChangeType.Modification, items[i]);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updateCollectionByServerId(List<T> items) async {
    try {
      var db = await initializeDB();
      var batch = db.batch();
      for (var entry in items) {
        await entry.beforeSave(true);
        var map = new Map<String, dynamic>();
        entry.creationTime.value = DateTime.now();
        entry.modificationTime.value = DateTime.now();
        _setEntryToMap(entry, map);
        batch.update(tableName, map,
            where: 'serverId = ${entry.serverId.value}');
        await entry.afterSave(true);
      }
      await batch.commit();
      for (int i = 0; i < items.length; i++) {
        // items[i].id = result[i];
        _fireChangeListners(EntryChangeType.Modification, items[i]);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> insertOrUpdateCollectionByServerId(List<T> items,
      {List<FieldWithValue>? fieldsToCopy}) async {
    try {
      //get serverIds
      List<int> itemServerIds = [
        for (var i in items)
          if (i.serverId.value != null) i.serverId.value!
      ];

      //get already inserted serverIds
      List<T> insertedItems =
          await select(where: (s) => s.serverId.inCollection(itemServerIds));

      var insertedServerIds =
          insertedItems.map<int>((e) => e.serverId.value!).toList();

      //Get items need to be updated
      for (var item in insertedItems) {
        var newItem =
            items.firstWhere((i) => i.serverId.value == item.serverId.value);
        item.copyValuesFrom(newItem, fieldsToCopy: fieldsToCopy);
      }

      await updateCollectionByServerId(insertedItems);

      //Get items need to be insered
      var newItems = items
          .where((e) => !insertedServerIds.contains(e.serverId.value))
          .toList();

      await insertCollection(newItems);
    } catch (e) {
      print('Error: $e');
      return;
    }
  }

  Future<bool> insertCollectionInTransaction(List<T> items) async {
    if (items.length == 0) return true;
    try {
      var db = await initializeDB() as sqflite.Database;
      await db.transaction((sqflite.Transaction tx) async {
        for (var entry in items) {
          await entry.beforeSave(true);
          var map = new Map<String, dynamic>();
          entry.creationTime.value = DateTime.now();
          entry.modificationTime.value = DateTime.now();
          _setEntryToMap(entry, map);
          tx.insert(tableName, map);
          await entry.afterSave(true);
          // _fireChangeListners(EntryChangeType.Insertion, entry);
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEntry(T entry) async {
    if (entry.id.value == null) return await insertEntry(entry);

    try {
      await entry.beforeSave(false);
      var db = await initializeDB();
      var map = new Map<String, dynamic>();
      entry.modificationTime.value = DateTime.now();
      _setEntryToMap(entry, map);
      await db.update(tableName, map, where: "$idColumnName=${entry.id.value}");
      await entry.afterSave(false);
      _fireChangeListners(EntryChangeType.Modification, entry);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEntryByServerId(T entry) async {
    try {
      await entry.beforeSave(false);
      var db = await initializeDB();
      var map = new Map<String, dynamic>();
      entry.modificationTime.value = DateTime.now();
      _setEntryToMap(entry, map);
      map.remove(idColumnName);
      await db.update(tableName, map,
          where: "serverId=${entry.serverId.value}");
      await entry.afterSave(false);
      _fireChangeListners(EntryChangeType.Modification, entry);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _setEntryToMap(T entry, Map map) {
    var fields = entry.getAllFields();
    for (var f in fields) map[f!.columnName] = f.dbValue;
  }

  final T Function() factoryOfT;
  DbTableProvider(this.factoryOfT, {this.specialDbFile});
  T _createInstance() {
    T result = factoryOfT();
    result.getAllFields().forEach((e) {
      e!.tableName = this.tableName;
    });
    return result;
  }

  T _entryFromMap(Map<String, dynamic> r) {
    T e = _createInstance();
    var fields = e.getAllFields();

    for (var e in r.entries) {
      FieldWithValue? f = fields.firstWhere(
          (element) => element?.columnName == e.key,
          orElse: () => null);
      if (f != null) f.dbValue = e.value;
    }
    return e;
  }

  T entryFromMap(Map<String, dynamic> r) => _entryFromMap(r);

  Future<DataPageQueryResult<T>> loadAllEntriesByPaging(
      {required DataPageQuery<T> pageQuery,
      ConditionQuery Function(T model)? where,
      List<OrderField> Function(T model)? orderBy,
      List<FieldWithValue> Function(T model)? desiredFields}) async {
    int count = await countEntries(where: where);
    return DataPageQueryResult<T>(
        count,
        await select(
            limit: pageQuery.resultsPerPage,
            offset: (pageQuery.page - 1) * pageQuery.resultsPerPage,
            where: where,
            orderBy: orderBy,
            desiredFields: desiredFields),
        pageQuery.page,
        pageQuery.resultsPerPage);
  }

  Future<T?> loadEntryById(int id) async {
    var result = (await select(where: (m) => m.id.equals(id), limit: 1));
    return result.length > 0 ? result.first : null;
  }

  Future<T?> loadEntryByServerId(int serverId) async {
    var result =
        (await select(where: (m) => m.serverId.equals(serverId), limit: 1));
    return result.length > 0 ? result.first : null;
  }

  Future<int> countEntries({
    ConditionQuery Function(T model)? where,
  }) async {
    return await queryFirstValue((s) => s.id.count(), where: where);
  }

  Future<int> deleteEntry(T entry) async {
    await entry.beforeDelete();

    int result = 0;
    var db = await initializeDB();
    result =
        await db.delete(tableName, where: "$idColumnName=${entry.id.value}");

    await entry.afterDelete();
    _fireChangeListners(EntryChangeType.Deletion, entry);
    return result;
  }

  Future deleteAllEntries() async {
    await delete();
  }

  Future<List<T>> getEntriesByIds(List<int> ids) async {
    return await select(where: (r) => r.id.inCollection(ids));
  }

  Future<T?> getRandomEntry({ConditionQuery Function(T model)? where}) async {
    return selectFirst(where: where, orderBy: (s) => [s.id.randomOrder]);
  }

  bool _processing = false;
  List<Function()> _watchers = [];

  @protected
  set isProcessing(bool value) {
    if (value != _processing) {
      _processing = value;
      callWatchers();
    }
  }

  bool get isProcessing => _processing;

  void callWatchers() {
    for (var w in _watchers) w.call();
  }

  void addListener(Function() listener) => _watchers.add(listener);
  void removeListener(Function() listener) => _watchers.remove(listener);

  Future<List<T>> selectWhere(ConditionQuery Function(T e) where,
          {List<OrderField> Function(T e)? orderBy,
          int? offset,
          int? limit,
          List<FieldWithValue> Function(T e)? desiredFields}) async =>
      select(
          where: where,
          orderBy: orderBy,
          offset: offset,
          limit: limit,
          desiredFields: desiredFields);

  Future<List<T>> select(
      {ConditionQuery Function(T e)? where,
      List<OrderField> Function(T e)? orderBy,
      int? offset,
      int? limit,
      List<FieldWithValue> Function(T e)? desiredFields}) async {
    List<T> result = [];

    for (var r in await query(
        queries: desiredFields,
        where: where,
        orderBy: orderBy,
        offset: offset,
        limit: limit)) {
      T entry = _entryFromMap(r);
      result.add(entry);
    }
    return result;
  }

  Future query(
      {List<QueryPart> Function(T e)? queries,
      ConditionQuery Function(T e)? where,
      ConditionQuery Function(T e)? having,
      int? offset,
      int? limit,
      List<FieldWithValue> Function(T e)? groupBy,
      List<OrderField> Function(T e)? orderBy}) async {
    List<QueryPart> Function(T a, DbModel? b)? quers;
    if (queries != null) {
      quers = (a, b) => queries.call(a).map((e) => e).toList();
    }
    return _query(
        queries: quers,
        where: where,
        offset: offset,
        having: having,
        limit: limit,
        groupBy: groupBy,
        orderBy: orderBy);
  }

  Future _queryJoin<O extends DbModel>(
      {List<QueryPart> Function(T a, O? b)? queries,
      Function(T a, O b)? joinCondition,
      DbTableProvider<O>? otherJoinTable,
      String? joinType,
      ConditionQuery Function(T e)? where,
      int? offset,
      int? limit,
      List<FieldWithValue> Function(T e)? groupBy,
      List<OrderField> Function(T e)? orderBy}) async {
    return _query(
        queries: queries,
        joinCondition: joinCondition,
        joinType: joinType,
        otherJoinTable: otherJoinTable,
        where: where,
        offset: offset,
        limit: limit,
        groupBy: groupBy,
        orderBy: orderBy);
  }

  Future innerJoinQuery<O extends DbModel>(
      List<QueryPart> Function(T a, O? b) queries,
      ConditionQuery Function(T a, O? b) joinCondition,
      DbTableProvider<O> otherJoinProvider,
      ConditionQuery Function(T e) where,
      int offset,
      int limit,
      List<FieldWithValue> Function(T e) groupBy,
      List<OrderField> Function(T e) orderBy) async {
    return _queryJoin(
        queries: queries,
        joinCondition: joinCondition,
        joinType: 'INNER',
        otherJoinTable: otherJoinProvider,
        where: where,
        offset: offset,
        limit: limit,
        groupBy: groupBy,
        orderBy: orderBy);
  }

  Future leftJoinQuery<O extends DbModel>(
      List<QueryPart> Function(T a, O? b) queries,
      ConditionQuery Function(T a, O b) joinCondition,
      DbTableProvider<O> otherJoinProvider,
      ConditionQuery Function(T e) where,
      int offset,
      int limit,
      List<FieldWithValue> Function(T e) groupBy,
      List<OrderField> Function(T e) orderBy) async {
    return _queryJoin(
        queries: queries,
        joinCondition: joinCondition,
        joinType: 'LEFT',
        otherJoinTable: otherJoinProvider,
        where: where,
        offset: offset,
        limit: limit,
        groupBy: groupBy,
        orderBy: orderBy);
  }

  Future _query<O extends DbModel>(
      {List<QueryPart> Function(T a, O? b)? queries,
      DbTableProvider<O>? otherJoinTable,
      Function(T a, O b)? joinCondition,
      String? joinType,
      ConditionQuery Function(T e)? where,
      ConditionQuery Function(T e)? having,
      int? offset,
      int? limit,
      List<FieldWithValue> Function(T e)? groupBy,
      List<OrderField> Function(T e)? orderBy}) async {
    var a = _createInstance();
    var b = otherJoinTable?._createInstance();
    String queryString = '';
    List queryArgs = [];
    var queriesResults = queries == null ? null : queries(a, b);

    if (queriesResults == null || queriesResults.length == 0)
      queryString = '*';
    else {
      queriesResults.forEach((element) {
        var q = element.buildQuery();
        queryString += q + ',';
        queryArgs.addAll(element.getParameters());
      });

      queryString = queryString.substring(0, queryString.length - 1);
    }
    queryString = 'SELECT $queryString FROM $tableName';

    if (joinCondition != null && joinType != null && otherJoinTable != null) {
      String joinString = ' $joinType JOIN ${otherJoinTable.tableName}';

      var abQuery = joinCondition(a, b!);
      joinString += ' ON';
      joinString += abQuery.buildQuery();
      queryString += ' $joinString ';
      queryArgs.addAll(abQuery.getParameters());
    }
    String? whereString;
    List? whereArgs;
    ConditionQuery whereConditions;
    if (where != null) {
      whereConditions = where(a);
      whereString = whereConditions.buildQuery();
      whereArgs = whereConditions.getParameters();
    }

    if (whereString != null) queryString += ' WHERE $whereString';
    if (whereArgs != null) queryArgs.addAll(whereArgs);

    String groupByText;
    if (groupBy != null) {
      groupByText = '';
      var goupByQueries = groupBy(a).toList();
      groupByText = goupByQueries
          .map((e) => e.buildQuery())
          .toList()
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '');

      goupByQueries.forEach((element) {
        queryArgs.addAll(element.getParameters());
      });

      queryString += ' GROUP BY $groupByText';
      if (having != null) {
        var havingQuery = having(a);
        queryString += ' HAVING ' + havingQuery.buildQuery();
        queryArgs.addAll(havingQuery.getParameters());
      }
    }
    String? orderByText;
    if (orderBy != null) {
      orderByText = '';
      var orderQueries = orderBy(a).toList();
      orderByText = orderQueries
          .map((e) => e.buildQuery())
          .toList()
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '');

      orderQueries.forEach((element) {
        queryArgs.addAll(element.getParameters());
      });
    }
    if (orderByText != null) queryString += ' ORDER BY $orderByText';

    if (limit != null) queryString += ' LIMIT $limit';
    if (offset != null) queryString += ' OFFSET $offset';
    var db = await initializeDB();
    var results = await (db).rawQuery(queryString, queryArgs);

    var r = results.toList();
    return r;
  }

  Future delete({
    ConditionQuery Function(T e)? where,
  }) async {
    for (var entry in await select(where: where)) await deleteEntry(entry);
  }

  Future queryFirstValue(QueryPart Function(T model) query,
      {ConditionQuery Function(T model)? where,
      List<OrderField> Function(T model)? orderBy}) async {
    // assert(query != null);
    var result = await this.query(
        queries: (model) => [query.call(model)],
        where: where,
        limit: 1,
        orderBy: orderBy);

    if (result != null) {
      if (result is List) {
        if (result.length > 0) if (result[0] != null) return result[0].row[0];
      }
    }
    return null;
  }

  Future<T?> selectFirst(
      {ConditionQuery Function(T model)? where,
      List<OrderField> Function(T model)? orderBy,
      int? offset,
      List<FieldWithValue> Function(T model)? desiredFields}) async {
    var result = (await select(
        where: where, orderBy: orderBy, limit: 1, offset: offset));
    return result.length > 0 ? result.first : null;
  }

  Future<T?> selectFirstWhere(ConditionQuery Function(T model) where,
      {List<OrderField> Function(T model)? orderBy,
      int? offset,
      List<FieldWithValue> Function(T model)? desiredFields}) async {
    var result = (await select(
        where: where, orderBy: orderBy, limit: 1, offset: offset));
    return result.length > 0 ? result.first : null;
  }

  List<Function(EntryChangeType changeType, T entry)> _entryListners = [];

  void addEntryChangeListner(
          Function(EntryChangeType changeType, T entry) lisnter) =>
      _entryListners.add(lisnter);

  void removeEntryChangeListner(
          Function(EntryChangeType changeType, T entry) lisnter) =>
      _entryListners.remove(lisnter);

  void _fireChangeListners(EntryChangeType type, T entry) =>
      _entryListners.forEach((element) => element.call(type, entry));
}
