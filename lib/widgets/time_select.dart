/// PillPal
///
/// Shows the page that allows the user to select the times
/// they want to take their medication.

import 'package:flutter/material.dart';

class TimeSelect extends StatefulWidget {
  final Map<String, dynamic> data;

  TimeSelect(this.data);
  @override
  State<StatefulWidget> createState() {
    return TimeSelectState(data);
  }
}

class TimeSelectState extends State<TimeSelect> {
  Map<String, dynamic> data;
  late List<DateTime> selectedTimes;

  TimeSelectState(this.data) {
    if (data['times'] == null) {
      data['times'] = <DateTime>[];
    }
    selectedTimes = data['times'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Time Selection'),
      ),
      body: Column(
        children: <Widget>[
          // List of Times to choose from.
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              // Using 24-Hour time with increments of 30 minutes.
              itemCount: 24 * 2,
              itemBuilder: (BuildContext context, int index) {
                DateTime time = DateTime(1, 1, 1, index ~/ 2, (index % 2) * 30);
                String timeString =
                    '${index ~/ 2}:${(index % 2) * 30}${index % 2 == 0 ? '0' : ''}';
                // Set of values
                return ListTile(
                  title: Text(timeString),
                  trailing: Icon(
                    selectedTimes.contains(time)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  onTap: () {
                    setState(() {
                      if (selectedTimes.contains(time)) {
                        selectedTimes.remove(time);
                      } else {
                        selectedTimes.add(time);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
