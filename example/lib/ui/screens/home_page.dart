import 'package:flutter/material.dart';
import 'package:example/data/note.dart';
import 'package:example/data/notes_provider.dart';
import 'package:quds_db/quds_db/entry_change_type.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes = [];

  @override
  void initState() {
    _loadData();
    notesProvider.addEntryChangeListner((changeType, entry) {
      setState(() {
        switch (changeType) {
          case EntryChangeType.Insertion:
            notes.add(entry);
            break;
          case EntryChangeType.Deletion:
            notes.remove(entry);
            break;
          case EntryChangeType.Modification:
            //(entry) has been modified
            break;
        }
      });
    });
    super.initState();
  }

  Future<void> _loadData() async {
    notes.addAll(await notesProvider.select());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView(
        children: [for (var n in notes) _buildNote(n)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'add note',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildNote(Note n) {
    return ListTile(
      title:
          Text((n.isImportant.value! ? '[Important] ' : '') + n.title.value!),
      subtitle: Text(n.content.value!),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await notesProvider.deleteEntry(n);
        },
      ),
      leading: CircleAvatar(
        backgroundColor: n.color.value,
      ),
    );
  }

  Future<void> _addNote() async {
    Note n = Note();
    n.title.value = 'New note';
    n.content.value = 'Note content, descripe your self';
    n.isImportant.value = ([true, false]..shuffle()).first;
    n.color.value = ([Color(0xffff0000), Color(0xff00ff00), Color(0xff0000ff)]
          ..shuffle())
        .first;

    await notesProvider.insertEntry(n);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New Note added with id:${n.id}')));
  }
}
