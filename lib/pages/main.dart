import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/models/todoitem.dart';
import 'package:untitled/pages/calendar.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ToDoItemAdapter());
  await Hive.openBox<List<dynamic>>('events');

  runApp(RestorationScope(restorationId: 'root', child: MyApp()));

}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UB_TEST_TASK",
      home: Calendar(),
    );
  }
}