import 'package:quds_db/quds_db.dart';

class Note extends DbModel {
  var title = StringField(columnName: 'title');
  var content = StringField(columnName: 'content');
  // var isImportant = BoolField(columnName: 'isImportant');
  var color = ColorField(columnName: 'color');
  var importance = EnumField<Importance>(columnName: 'mmm', valuesMap: {
    1: Importance.normal,
    2: Importance.important,
    3: Importance.veryImportant,
  });

  var jsonData =
      JsonField(columnName: 'jsonTest', defaultValue: {'hi': 'مرحبا'});

  @override
  List<FieldWithValue>? getFields() =>
      [title, content, color, importance, jsonData];
}

enum Importance { normal, important, veryImportant }
