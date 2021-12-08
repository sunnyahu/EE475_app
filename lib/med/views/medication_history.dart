/// PillPal
///
/// This file stores the "View History" for a given medication,
/// showing when the medication was taken.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

class MedicationHistory extends StatelessWidget {
  final String name;
  final List<DateTime> data;

  const MedicationHistory({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  var history = data[index];
                  String displayMinute = history.minute < 10
                      ? "0" + history.minute.toString()
                      : history.minute.toString();
                  return ListTile(
                    title: Text(
                      '${history.day}/${history.month}/${history.year} - ${history.hour}:$displayMinute',
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
