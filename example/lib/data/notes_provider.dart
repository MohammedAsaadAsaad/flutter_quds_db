import 'package:quds_db/quds_db.dart';
import 'note.dart';

NotesProvider notesProvider = NotesProvider();

class NotesProvider extends DbTableProvider<Note> {
  NotesProvider() : super(() => Note());

  @override
  String get tableName => 'Notes';
}
