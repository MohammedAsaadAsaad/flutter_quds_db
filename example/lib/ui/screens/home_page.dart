import 'package:flutter/material.dart';
import 'package:example/data/note.dart';
import 'package:example/data/notes_provider.dart';
import 'package:quds_db/quds_db.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

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

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await notesProvider.deleteAllEntries(withRelatedItems: false);
              notes.clear();
              _loadData();
            },
          ),
          if (notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () async {
                // var n = await notesProvider.selectFirstWhere(
                //     (model) => model.jsonArrayData.arrayLength > 1);
              },
            )
        ],
        title: Text(widget.title!),
      ),
      body: ListView(
        children: [for (var n in notes) _buildNote(n)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addNotes();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('new notes added'),
              duration: Duration(milliseconds: 200),
            ),
          );
        },
        tooltip: 'add notes',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildNote(Note n) {
    return ListTile(
      title: Text('[${(n.importance.value ?? Importance.normal).toString()}] ' +
          n.title.value!),
      subtitle: Text(n.content.value!),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await notesProvider.deleteEntry(n);
        },
      ),
      leading: CircleAvatar(
        backgroundColor: n.color.value,
      ),
    );
  }

  Future<void> _addNotes() async {
    var notes = [
      for (var i = 0; i < 100; i++)
        Note()
          ..jsonArrayData.value = ['Hi', 4, 0.6]
          ..title.value = 'New note'
          ..content.value = 'Note content, describe your self'
          ..importance.value = (Importance.values.toList()..shuffle()).first
      ..color.value = ([
        const Color(0xffff0000),
        const Color(0xff00ff00),
        const Color(0xff0000ff)
      ]..shuffle())
          .first
    ];

    await notesProvider.insertCollection(notes);
  }
}
