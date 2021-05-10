import 'package:quds_db/quds_db.dart';

class Note extends DbModel {
  var title = StringField(columnName: 'title');
  var content = StringField(columnName: 'content');
  var isImportant = BoolField(columnName: 'isImportant');
  var color = ColorField(columnName: 'color');

  @override
  List<FieldWithValue>? getFields() => [title, content, isImportant, color];
}
