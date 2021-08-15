import 'package:hive/hive.dart';

part 'todoitem.g.dart';

@HiveType(typeId: 0)
class ToDoItem extends HiveObject{

  @HiveField(1)
  final String hour;

  @HiveField(2)
  final String minute;

  @HiveField(3)
  final String event;

  ToDoItem({required this.hour, required this.minute, required this.event});

  @override
  String toString() {
    return '$hour:$minute - $event';
  }
}
