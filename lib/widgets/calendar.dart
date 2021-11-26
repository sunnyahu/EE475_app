// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
// From: https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/pages/basics_example.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../med/data/medication.dart';

@immutable
class Calendar extends StatefulWidget {
  final String text;
  final String date;
  final Medication medication;

  const Calendar({
    Key? key,
    required this.text,
    required this.date,
    required this.medication,
  }) : super(key: key);

  @override
  CalendarState createState() => CalendarState(text, date, medication);
}

class CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  String text;
  String date; // Determines if user is selecting the start or end date.
  Medication medication;

  CalendarState(this.text, this.date, this.medication) {
    DateTime? dateobj = medication.get(date);
    if (dateobj != null) {
      _focusedDay = dateobj;
    } else {
      _focusedDay = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime(
              _focusedDay.year,
              _focusedDay.month - 1,
              _focusedDay.day,
            ),
            lastDay: DateTime(
              _focusedDay.year,
              _focusedDay.month + 1,
              _focusedDay.day,
            ),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              medication.set(date, _selectedDay);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
