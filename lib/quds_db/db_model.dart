import '../quds_db.dart';

abstract class DbModel {
  var id = IdField();
  var serverId = IntField(columnName: 'serverId', jsonMapName: 'id');
  var creationTime = DateTimeField(
    columnName: 'creationTime',
  );
  var modificationTime = DateTimeField(
    columnName: 'modificationTime',
  );

  DbModel();

  beforeDelete() async {}
  afterDelete() async {}
  beforeSave(bool isNew) async {}
  afterSave(bool isNew) async {}

  List<FieldWithValue>? getFields();

  List<FieldWithValue?> getAllFields() {
    var list = getFields();
    return [id, serverId, creationTime, modificationTime]..addAll(list ?? []);
  }

  ///[other] The other model want to copy values from
  ///
  ///[fullCopy] Copy values with (id, serverId, creationTime, modificationTime)
  void copyValuesFrom(DbModel other,
      {List<FieldWithValue>? fieldsToCopy, bool fullCopy = false}) {
    assert(this.runtimeType == other.runtimeType);

    var getCorrepondingField = (String name) {
      for (var f in this.getAllFields())
        if (f != null) if (f.columnName!.trim().toLowerCase() ==
            name.trim().toLowerCase()) return f;
    };
    List<FieldWithValue> fields = [];
    if (fieldsToCopy != null)
      for (var f in fieldsToCopy) {
        var corrField = getCorrepondingField(f.columnName!);
        if (corrField != null) fields.add(corrField);
      }
    Map<String?, FieldWithValue?> fieldsMap = new Map();
    (fullCopy
            ? this.getAllFields()
            : fieldsToCopy == null
                ? this.getFields()!
                : fields)
        .forEach((e) => fieldsMap[e?.columnName] = e);

    Map<String, FieldWithValue> otherFieldsMap = new Map();
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

      if (thisField != null && otherField != null)
        thisField.value = otherField.value;
    }
  }

  ///[other] The other model want to copy values from
  ///
  ///[allFields] Check (id, serverId, creationTime, modificationTime) values
  Iterable<FieldWithValue> differIn(DbModel other,
      {List<FieldWithValue>? fieldsToCheck, bool? allFields = true}) sync* {
    assert(allFields != null);
    assert(this.runtimeType == other.runtimeType);

    Map<String?, FieldWithValue> fieldsMap = new Map();
    (allFields!
            ? this.getAllFields()
            : fieldsToCheck == null
                ? this.getFields()!
                : fieldsToCheck)
        .forEach((e) => fieldsMap[e!.columnName] = e);

    Map<String, FieldWithValue> otherFieldsMap = new Map();
    (allFields
            ? other.getAllFields()
            : fieldsToCheck == null
                ? other.getFields()!
                : other._getNamedFields(
                    fieldsToCheck.map((e) => e.columnName).toList()))
        .forEach((e) => otherFieldsMap[e!.columnName!] = e);

//compare values
    for (var k in fieldsMap.keys) {
      var thisValue = fieldsMap[k]!.value;
      var otherValue = otherFieldsMap[k]!.value;

      if (thisValue != otherValue) {
        yield fieldsMap[k]!;
      }
    }
  }

  ///[other] The other model want to copy values from
  ///
  ///[allFields] Check (id, serverId, creationTime, modificationTime) values
  bool differ(DbModel other,
      {List<FieldWithValue>? fieldsToCheck, bool allFields = true}) {
    return differIn(other, fieldsToCheck: fieldsToCheck, allFields: allFields)
            .length >
        0;
  }

  List<FieldWithValue?> _getNamedFields(List<String?> fields) => getAllFields()
      .where((element) => fields.contains(element?.columnName))
      .toList();

  void fromMap(Map<String, dynamic> m) {
    var fields = getAllFields();
    for (var f in fields)
      if (f?.jsonMapName != null) {
        if (m.containsKey(f?.jsonMapName)) {
          try {
            var v = DbHelper.getMapValue(m[f?.jsonMapName], f!.valueType);
            f.value = v;
          } catch (e) {
            print(e);
          }
        }
      }
  }

  // Map<String, dynamic> toMap() {
  //   Map result = Map();

  //   return result;
  // }
}