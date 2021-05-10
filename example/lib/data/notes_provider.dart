import 'package:quds_db/quds_db/db_table_provider.dart';
import 'note.dart';

NotesProvider notesProvider = NotesProvider();

class NotesProvider extends DbTableProvider<Note> {
  NotesProvider() : super(() => Note());

  @override
  String get tableName => 'Notes';
}
