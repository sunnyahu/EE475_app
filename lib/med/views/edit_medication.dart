/// PillPal
///
/// This file stores the "Add/Edit Medication" page which appears when
/// the user clicks the button in the bottom right of the home page
/// to add a new medication, or when they click on "Edit/View Information"
/// on a specific medication.
///

import 'package:flutter/material.dart';
import 'package:pill_pal/widgets/calendar.dart';

import '../../widgets/input.dart';
import '../../med/data/medication.dart';
import '../../widgets/calendar.dart';
import '../../widgets/time_select.dart';
import '../../widgets/dosage_select.dart';
import '../../blue/services/register_bottle.dart';

class EditMedication extends StatefulWidget {
  final List<Medication> medications;
  final Medication? medication;

  EditMedication(this.medications, this.medication);
  @override
  State<StatefulWidget> createState() {
    return EditMedicationState(medications, medication);
  }
}

class EditMedicationState extends State<EditMedication> {
  late bool push;
  late bool leftBehind;
  late String timesString;
  late String startDateString;
  late String endDateString;

  Medication? medication;
  final List<Medication> medications;
  // "data" is used to keep track of the user responses.
  // Once they click "save", all the information in "data" is copied into the
  // medication object.
  final Map<String, dynamic> data = {};
  late bool isNew;
  // Internally used to check which required fields the user did not fill out.
  List<String> missing = [];

  EditMedicationState(this.medications, medication) {
    isNew = medication == null;
    if (isNew) {
      int id = registerBottle();
      this.medication = Medication(id);
      data['dosage'] = 1; // Set 1 as default for dosage.
      push = false;
      leftBehind = false;
      timesString = "Times";
      startDateString = "Start Date";
      endDateString = "End Date";
    } else {
      this.medication = medication;
      data['dosage'] = medication.prescription['dosage'];
      push = medication.notificationSettings['push'];
      leftBehind = medication.notificationSettings['left_behind'];
      //print(medication.prescription['times'][0].minute);
      timesString = medication.prescription['times'].map((time) {
        return "${time.hour}:${time.minute}${time.minute == 0 ? '0' : ''}";
      }).join(', ');
      timesString = "Times: $timesString";
      data['times'] = medication.prescription['times'];
      DateTime start = medication.prescription['start_date'];
      data['start_date'] = start;
      startDateString = "Start Date: ${start.month}-${start.day}-${start.year}";
      DateTime? end = medication.prescription['end_date'];
      if (end != null) {
        data['end_date'] = end;
        endDateString = "End Date: ${end.month}-${end.day}-${end.year}";
      } else {
        endDateString = "End Date";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNew ? 'Add Medication' : medication!.prescription['name'],
        ),
      ),
      body: Column(
        children: <Widget>[
          Input('${!isNew ? "Update " : ""}Prescription/Medication Name', data,
              'name'),
          ListTile(
            title: Text("Dosage: ${data['dosage']}"),
            trailing: const Icon(Icons.medication),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DosageSelect(data, 10, data['dosage']),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {});
              });
            },
          ),
          ListTile(
            title: Text(timesString),
            trailing: const Icon(Icons.access_time_filled),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimeSelect(data),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {
                  Set<DateTime> times = data['times']!;
                  if (times.isNotEmpty) {
                    timesString = times.map((time) {
                      String pad = time.minute == 0 ? '0' : '';
                      return "${time.hour}:${time.minute}$pad";
                    }).join(', ');
                    timesString = "Times: $timesString";
                  }
                });
              });
            },
          ),
          ListTile(
            title: Text(startDateString),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Calendar('Start Date', 'start_date', data),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {
                  if (data.containsKey('start_date')) {
                    DateTime start = data['start_date'];
                    startDateString =
                        "Start Date: ${start.month}-${start.day}-${start.year}";
                  }
                });
              });
            },
          ),
          ListTile(
            title: Text(endDateString),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Calendar('End Date', 'end_date', data),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {
                  if (data.containsKey('end_date')) {
                    DateTime end = data['end_date'];
                    endDateString =
                        "End Date: ${end.month} ${end.day}-${end.year}";
                  }
                });
              });
            },
          ),
          ListTile(
            title: Text(
              (leftBehind ? 'Disable' : 'Enable') +
                  ' Bottle Left Behind Notifications',
            ),
            trailing: Icon(
              leftBehind ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onTap: () {
              setState(() {
                leftBehind = !leftBehind;
              });
            },
          ),
          ListTile(
            title: Text(
              (push ? 'Disable' : 'Enable') + ' Push Notifications',
            ),
            trailing: Icon(
              push ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onTap: () {
              setState(() {
                push = !push;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              missing.clear();
              Map<String, String> mapping = {
                'name': 'Name',
                'times': 'Times',
                'start_date': 'Start Date'
              };
              // Check if all required fields are filled.
              // dosage is 1 by default.
              // end_date is not required since some patients may have
              // chronic conditions.
              for (final key in ['name', 'times', 'start_date']) {
                if (data.containsKey(key)) {
                  if (key == 'times') {
                    medication!.prescription['times'].addAll(data['times']);
                  } else {
                    medication!.prescription[key] = data[key];
                  }
                } else {
                  missing.add(mapping[key]!);
                }
              }
              if (data['end_date'] != null) {
                medication!.prescription['end_date'] = data['end_date'];
              }
              medication!.notificationSettings['left_behind'] = leftBehind;
              medication!.notificationSettings['push'] = push;
              medication!.prescription['dosage'] = data['dosage'];

              if ((isNew && missing.isEmpty) || !isNew) {
                if (isNew) {
                  // Add medication to list.
                  medications.add(medication!);
                }
                Navigator.pop(context);
              } else if (isNew && missing.isNotEmpty) {
                showAlertDialog(context, missing.join(', '));
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Shows an alert dialog to tell user to enter required information.
  showAlertDialog(BuildContext context, String message) {
    // set up the buttons
    Widget okayButton = TextButton(
      child: const Text('Okay'),
      onPressed: () {
        // Close the dialog window.
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Missing Required Information'),
      content: Text('Missing: $message'),
      actions: [
        okayButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
