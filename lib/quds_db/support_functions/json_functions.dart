part of 'support_functions.dart';

void _addJsonFunctions(Database db) {
  db.createFunction(
      functionName: 'json_array_length',
      argumentCount: AllowedArgumentCount(1),
      function: (s) {
        var arg = s[0] as String?;
        if (arg == null) return 0;
        var array = json.decode(arg);
        return array is List ? array.length : 0;
      });

  db.createFunction(
      functionName: 'contains_key',
      argumentCount: AllowedArgumentCount(2),
      function: (s) {
        var js = s[0] as String?;
        var arg = s[1] as String?;
        if (js == null || arg == null) return false;
        var map = json.decode(js);
        return map is Map ? map.containsKey(arg) : false;
      });

  db.createFunction(
      functionName: 'key_equals',
      argumentCount: AllowedArgumentCount(3),
      function: (s) {
        var js = s[0] as String?;
        var key = s[1] as String?;
        var value = s[2];
        if (js == null || key == null) return false;
        var map = json.decode(js);
        return map is Map ? map[key] == value : false;
      });
}
