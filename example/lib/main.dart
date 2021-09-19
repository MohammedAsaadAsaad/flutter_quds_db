import 'package:example/data/notes_provider.dart';
import 'package:flutter/material.dart';
import 'ui/screens/home_page.dart';

void main() async {
  var result = await notesProvider.query(
      queries: (n) => [
            n.jsonArrayData.asNamed('arr'),
            n.jsonArrayData
                .removeAt(1)
                .insertAt(0, 7)
                .add(10)
                .asNamed('arr_after')
          ]);
  print(result);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quds Db Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Quds Db Example'),
    );
  }
}
