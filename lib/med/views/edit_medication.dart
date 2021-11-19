/// PillPal
///
/// This file stores the "Add/Edit Medication" page which appears when
/// the user clicks the button in the bottom right of the home page
/// to add a new medication, or when they click on "Edit/View Information"
/// on a specific medication.
///

import 'package:flutter/material.dart';
import 'package:pill_pal/widgets/calendar.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../widgets/input.dart';
import '../../med/data/medication.dart';
import '../../widgets/calendar.dart';
import '../../widgets/time_select.dart';
import '../../widgets/dosage_select.dart';

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
  bool push = false;
  bool leftBehind = false;

  Medication? medication;
  final List<Medication> medications;
  final Map<String, dynamic> data = {};

  late bool isNew;

  EditMedicationState(this.medications, medication) {
    data['dosage'] = 1;
    data['start_date'] = DateTime.now();
    data['end_date'] = DateTime.now();
    isNew = medication == null;
    if (isNew) {
      int id = 0; // TODO: get the next available id from bluetooth

      FlutterBlue flutterBlue = FlutterBlue.instance;
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      var subscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult device in results) {
          // device is a bluetooth device
        }
      });
      // Stop scanning
      flutterBlue.stopScan();

      medication = Medication(id);
    } else {
      this.medication = medication;
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
          Input('Prescription/Medication Name', data, 'name'),
          ListTile(
            title: Text('Dosage: ${data["dosage"]}'),
            trailing: const Icon(Icons.medication),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DosageSelect(data, 10),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {});
              });
            },
          ),
          ListTile(
            title: Text('Times: ${data["times"]}'),
            trailing: const Icon(Icons.access_time_filled),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimeSelect(data),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {});
              });
            },
          ),
          ListTile(
            title: Text(
              'Start Date: ${DateUtils.dateOnly(data["start_date"])}',
            ),
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
                setState(() {});
              });
            },
          ),
          ListTile(
            title: Text(
              'End Date: ${DateUtils.dateOnly(data["end_date"])}',
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Calendar('End Date', 'end_date', data),
                ),
              ).then((value) {
                // Reload Page.
                setState(() {});
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
              List<String> missing = [];
              for (final key in [
                'name',
                'dosage',
                'times',
                'start_date',
                'end_date'
              ]) {
                if (data.containsKey(key)) {
                  medication!.prescription[key] = data[key];
                } else {
                  missing.add(key);
                }
              }
              medication!.notificationSettings['leftBehind'] = leftBehind;
              medication!.notificationSettings['push'] = push;

              if ((isNew && missing.isEmpty) || !isNew) {
                Navigator.pop(context);
              } else if (missing.isNotEmpty && isNew) {
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
