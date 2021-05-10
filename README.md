# Quds Db
Is an automated version of sqflite!

## How to use
#### 1. To create a model
Model classes should extend DbModel class.
Define the schema of your model,
Supported field type:
|Integers|Strings|DateTimes|Others|
|-|-|-|-|
|IdField|StringField|DateTimeField (saved as num)|BlobField|
IntField||DateTimeStringField (Saved as string)|BoolField|
|NumField|||ColorField|
|DoubleField||

```
class Note extends DbModel {
  var title = StringField(columnName: 'title');
  var content = StringField(columnName: 'content');
  var isImportant = BoolField(columnName: 'isImportant');
  var color = ColorField(columnName: 'color');

  @override
  List<FieldWithValue>? getFields() => [title, content, isImportant, color];
}
```
<b>Note that:</b>
Every model has default fields:
- id (Auto incremental integer field)
- creationTime (automatically set once when created)
- modificationTime (automatically set when created, and with every update operation)

<br/>
#### 2. To create a table manager
```
class NotesProvider extends DbTableProvider<Note> {
  NotesProvider() : super(() => Note());

  @override
  String get tableName => 'Notes';
}
```
As shown, to set the name of the table:
```
  @override
  String get tableName => 'Notes';
```

<b>Note that:</b>
In provider class constructor, you should provide it with model object creation function.
```
  NotesProvider() : super(() => Note());
```

To create a provider instance,

```
NotesProvider notesProvider = NotesProvider();
```


#### 3. Crud operations: 
##### Creation: (Insertion)
<b> single:</b>
``` 
    Note n = Note();
    n.title.value = 'New note';
    n.content.value = 'Note content, descripe your self';
    n.isImportant.value = ([true, false]..shuffle()).first;
    n.color.value = ([Colors.red, Colors.blue, Colors.yellow, Colors.orange]
          ..shuffle())
        .first;

    await notesProvider.insertEntry(n);
```
    
<b> multiple</b>:
```
    await notesProvider.insertCollection([n1,n2,n3,...]);
```

##### Reading (Query):
```
var allNotes = await notesProvider.select();
var importantNotes = await notesProvider.select(where:(n)=>n.isImportant.isTrue);
var imortantRed = await notesProvider.select(where:(n)=>n.isImportant.isTrue & n.color.equals(Color(0xffff0000)));
```

##### Updating:
```
n.title = 'new title';
await notesProvider.updateEntry(n);
```

##### Deletion:
```
await notesProvider.deleteEntry(n);
```


## Monitoring changes:
To capture the changes in some table:
```
  notesProvider.addEntryChangeListner((changeType, entry) {
      switch (changeType) {
        case EntryChangeType.Insertion:
          //New Note added (entry)
          break;
        case EntryChangeType.Deletion:
          //(entry) has been deleted
          break;
        case EntryChangeType.Modification:
          //(entry) has been modified
          break;
      }
    });
```

## Database location:
Where are the data being stored?
By default, your data will be saved in app data folder / 'data.db',
and to change it:
```
  DbHelper.mainDbPath = 'your db path';
```

And if you want to save a table provider in specified file,
```
class NotesProvider extends DbTableProvider<Note> {
  NotesProvider()
      : super(() => Note(), specialDbFile: 'your specified file path');

  @override
  String get tableName => 'Notes';
}
```

