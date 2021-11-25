/// PillPal
///
/// Shows the page that allows the user to select the times
/// they want to take their medication.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

@immutable
class TimeSelect extends StatefulWidget {
  final Medication medication;

  const TimeSelect(this.medication, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TimeSelectState(medication);
}

class TimeSelectState extends State<TimeSelect> {
  Medication medication;
  late List<DateTime> selectedTimes;

  TimeSelectState(this.medication) {
    selectedTimes = medication.times;
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
