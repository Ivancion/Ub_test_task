import 'package:hive/hive.dart';

class Boxes{
  static Box<List<dynamic>> getEvents() => Hive.box<List<dynamic>>('events');
}