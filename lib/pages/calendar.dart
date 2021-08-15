import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/pages/todolistroute.dart';
import 'package:hive/hive.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>{
  
  DateTime selectedDay = DateTime.now();
  
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }
  
  List<dynamic> _getEventsFromDay(DateTime date) {
    return Hive.box<List<dynamic>>('events').get(date.toString()) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("UB_TEST_TASK"),
        centerTitle: true,
      ),
      body: TableCalendar(

        headerStyle:
            HeaderStyle(formatButtonVisible: false, titleCentered: true),
        focusedDay: selectedDay,
        firstDay: DateTime(1990),
        lastDay: DateTime(2050),
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (DateTime selectDay, DateTime focusDay) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ToDoListRoute(
                        date: selectedDay,
                      )));
          setState(() {
            selectedDay = selectDay;
          });
        },
        calendarBuilders:
            CalendarBuilders(markerBuilder: (context, day, events) {
          if (events.length != 0) {
            return Container(
              margin: EdgeInsets.only(bottom: 35.0, left: 40.0),
              height: 18.0,
              width: 16.0,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.deepOrange),
              child: Text(
                events.length.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        }),
        eventLoader: _getEventsFromDay,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
