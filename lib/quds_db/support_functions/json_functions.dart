part of 'support_functions.dart';

void _addJsonFunctions(Database db) {
  db.createFunction(
      functionName: 'json_array_length',
      argumentCount: const AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as String?;
        if (arg == null) return 0;
        var array = json.decode(arg);
        return array is List ? array.length : 0;
      });

  db.createFunction(
      functionName: 'json_array_remove',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var list = s[0] as String?;
        var index = s[1] as int?;
        if (list == null || index == null) return s[0];
        var listJson = json.decode(list) as List?;
        if (listJson != null && index >= 0 && index < listJson.length) {
          listJson.removeAt(index);
          return json.encode(listJson);
        }
      });

  db.createFunction(
      functionName: 'json_array_insert',
      argumentCount: const AllowedArgumentCount(3),
      function: (s) {
        var list = s[0] as String?;
        var index = s[1] as int?;
        var entry = s[2];
        if (list == null || index == null) return s[0];
        var listJson = json.decode(list) as List?;
        if (listJson != null && index >= 0 && index < listJson.length) {
          listJson.insert(index, entry);
          return json.encode(listJson);
        }
      });

  db.createFunction(
      functionName: 'json_array_add',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var list = s[0] as String?;
        var entry = s[1];
        if (list == null) return s[0];
        var listJson = json.decode(list) as List?;
        if (listJson != null) {
          listJson.add(entry);
          return json.encode(listJson);
        }
      });

  db.createFunction(
      functionName: 'contains_key',
      argumentCount: const AllowedArgumentCount(2),
      function: (s) {
        var js = s[0] as String?;
        var arg = s[1] as String?;
        if (js == null || arg == null) return false;
        var map = json.decode(js);
        return map is Map ? map.containsKey(arg) : false;
      });

  db.createFunction(
      functionName: 'key_equals',
      argumentCount: const AllowedArgumentCount(3),
      function: (s) {
        var js = s[0] as String?;
        var key = s[1] as String?;
        var value = s[2];
        if (js == null || key == null) return false;
        var map = json.decode(js);
        return map is Map ? map[key] == value : false;
      });
}
