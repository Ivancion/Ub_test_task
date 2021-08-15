import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/todoitem.dart';
import 'package:untitled/utils/strings.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/boxes.dart';
import 'package:untitled/pages/calendar.dart';

class ToDoListRoute extends StatefulWidget {
  ToDoListRoute({required this.date});

  final DateTime date;

  @override
  _ToDoListRouteState createState() => _ToDoListRouteState(selectedDay: date);
}

class _ToDoListRouteState extends State<ToDoListRoute> {
  _ToDoListRouteState({required this.selectedDay});

  final box = Hive.box<List<dynamic>>("events");

  String hValue = Strings.hourStrs.first;
  String mValue = Strings.minuteStrs.first;
  String event = '';
  final DateTime selectedDay;
  List<dynamic> selectedEvents = [];

  @override
  void initState() {
    selectedEvents = box.get(selectedDay.toString()) ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Row(
        children: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: hValue,
                  items: Strings.hourStrs.map(builtMenuItem).toList(),
                  onChanged: (value) => setState(() => hValue = value!),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: mValue,
                  items: Strings.minuteStrs.map(builtMenuItem).toList(),
                  onChanged: (value) => setState(() => mValue = value!),
                ),
              )),
          Container(
            height: 40.0,
            width: 200.0,
            child: TextField(
              onChanged: (String value) {
                event = value;
              },
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  if (event.isNotEmpty) {
                    selectedEvents.add(
                        ToDoItem(hour: hValue, minute: mValue, event: event));
                    box.put(selectedDay.toString(), selectedEvents);
                  }
                });
              },
              color: Colors.blueAccent,
              iconSize: 40,
              icon: Icon(Icons.add_box_rounded))
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Calendar()));
          },
        ),
        title: Text('${DateFormat.yMMMd().format(selectedDay)}'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<List<dynamic>>>(
        valueListenable: Boxes.getEvents().listenable(keys: [selectedDay]),
        builder: (context, box, _) {
          if (box.get(selectedDay.toString()) != null) {
            final events = box.get(selectedDay.toString());
            return buildContent(events!);
          } else
            return buildContent(selectedEvents);
        },
      ),
    );
  }

  DropdownMenuItem<String> builtMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));

  Future addEvent(
      DateTime date, String hour, String minute, String event) async {
    final eventItem = ToDoItem(hour: hour, minute: minute, event: event);
    selectedEvents.add(eventItem);
    box.put(selectedDay.toString(), selectedEvents);
  }

  void deleteEvent(ToDoItem item) {
    item.delete();
  }

  Widget buildContent(List<dynamic> list) {
    if (list.isNotEmpty) {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    list.removeAt(index);
                    box.put(selectedDay.toString(), selectedEvents);
                  });
                },
                child: Card(
                  child: ListTile(
                    title: Text(list[index].toString()),
                  ),
                ));
          });
    } else
      return Center(
        child: Text(
          'No events yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
  }
}
