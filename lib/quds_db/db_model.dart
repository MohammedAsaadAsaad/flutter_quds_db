part of '../quds_db.dart';

/// Represents a class can be saved in the database.
///
/// Every [DbModel] has by default some fields.
///
/// `id` - `serverId` - `creationTime` - `modificationTime`
abstract class DbModel {
  /// The Id column of this model.
  var id = IdField();

  /// The server id column of this model.
  ///
  /// Used if this model has a co-cloud row in some server.
  var serverId = IntField(columnName: 'serverId', jsonMapName: 'id');

  /// The creation time of this model, its value set once automatically when created in db.
  var creationTime =
      DateTimeField(columnName: 'creationTime', jsonMapName: 'created_at');

  /// The modification time of this model, its value set automatically when created or modified in db.
  var modificationTime =
      DateTimeField(columnName: 'modificationTime', jsonMapName: 'updated_at');

  /// Create an instance of [DbModel].
  DbModel();

  /// Called automatically before this model deletion from db.
  /// For example if a student has multiple exam marks, all marks should be deleted before delete this model.
  beforeDelete() async {}

  /// Called automatically after this model be deleted from db.
  afterDelete() async {}

  /// Called automatically before this model saving in db.
  beforeSave(bool isNew) async {}

  /// Called automatically after this model be saved in db.
  afterSave(bool isNew) async {}

  /// Get a list of the new defined fields of this model without pre-created fields.
  List<FieldWithValue>? getFields();

  /// Get a list of all fields of this model with pre-created fields.
  List<FieldWithValue?> getAllFields() {
    var list = getFields();
    return [id, serverId, creationTime, modificationTime, ...?list];
  }

  /// Copy values from [other] db model fields to this fields.
  ///
  /// [other] The other model want to copy values from.
  ///
  /// [fullCopy] Copy values with (id, serverId, creationTime, modificationTime).
  void copyValuesFrom(DbModel other,
      {List<FieldWithValue>? fieldsToCopy, bool fullCopy = false}) {
    // assert(runtimeType == other.runtimeType);

    FieldWithValue? Function(String name) getCorrepondingField;
    getCorrepondingField = (String name) {
      for (var f in getAllFields()) {
        if (f != null) {
          if (f.columnName!.trim().toLowerCase() == name.trim().toLowerCase()) {
            return f;
          }
        }
      }
      return null;
    };
    List<FieldWithValue> fields = [];
    if (fieldsToCopy != null) {
      for (var f in fieldsToCopy) {
        var corrField = getCorrepondingField(f.columnName!);
        if (corrField != null) fields.add(corrField);
      }
    }
    Map<String?, FieldWithValue?> fieldsMap = {};
    for (var e in (fullCopy
        ? getAllFields()
        : fieldsToCopy == null
            ? getFields()!
            : fields)) {
      fieldsMap[e?.columnName] = e;
    }

    Map<String, FieldWithValue> otherFieldsMap = {};
    var otherFields = (fullCopy
        ? other.getAllFields()
        : fieldsToCopy == null
            ? other.getFields()
            : other._getNamedFields(
                fieldsToCopy.map((e) => e.columnName).toList()));
    otherFields?.forEach((e) => otherFieldsMap[e!.columnName!] = e);

//Copy values
    for (var k in fieldsMap.keys) {
      var thisField = fieldsMap[k];
      var otherField = otherFieldsMap[k];

      if (thisField != null && otherField != null) {
        thisField.value = otherField.value;
      }
    }
  }

  /// Get the fields that has different values.
  ///
  /// [other] The other model want to copy values from.
  ///
  /// [allFields] Check (id, serverId, creationTime, modificationTime) values.
  Iterable<FieldWithValue> differIn(DbModel other,
      {List<FieldWithValue>? fieldsToCheck, bool? allFields = true}) sync* {
    assert(allFields != null);
    // assert(runtimeType == other.runtimeType);

    Map<String?, FieldWithValue> fieldsMap = {};
    for (var e
        in (allFields! ? getAllFields() : fieldsToCheck ?? getFields()!)) {
      fieldsMap[e!.columnName] = e;
    }

    Map<String, FieldWithValue> otherFieldsMap = {};
    for (var e in (allFields
        ? other.getAllFields()
        : fieldsToCheck == null
            ? other.getFields()!
            : other._getNamedFields(
                fieldsToCheck.map((e) => e.columnName).toList()))) {
      otherFieldsMap[e!.columnName!] = e;
    }

//compare values
    for (var k in fieldsMap.keys) {
      var thisValue = fieldsMap[k]!.value;
      var otherValue = otherFieldsMap[k]!.value;

      if (thisValue != otherValue) {
        yield fieldsMap[k]!;
      }
    }
  }

  /// Check weather there are different in some fields values.
  ///
  /// [other] The other model want to copy values from
  ///
  /// [allFields] Check (id, serverId, creationTime, modificationTime) values
  bool differ(DbModel other,
      {List<FieldWithValue>? fieldsToCheck, bool allFields = true}) {
    return differIn(other, fieldsToCheck: fieldsToCheck, allFields: allFields)
        .isNotEmpty;
  }

  /// Get this model fields with thier names.
  List<FieldWithValue?> _getNamedFields(List<String?> fields) => getAllFields()
      .where((element) => fields.contains(element?.columnName))
      .toList();

  /// Set values of this model from json map.
  void fromMap(Map<String, dynamic> m) {
    var fields = getAllFields();
    for (var f in fields) {
      if (f?.jsonMapName != null) {
        if (m.containsKey(f?.jsonMapName)) {
          try {
            var v = DbHelper._getMapValue(m[f?.jsonMapName], f!.valueType);
            f.value = v;
          } catch (e) {
            // ignore: avoid_print
            print(e);
          }
        }
      }
    }
  }

  // Map<String, dynamic> toMap() {
  //   Map result = Map();

  //   return result;
  // }
}
