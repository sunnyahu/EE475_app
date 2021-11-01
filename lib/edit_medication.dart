// The "Add Medication Page"
// Opens when the user clicks the add button in the buttom right of the
// main page.

import 'package:flutter/material.dart';

import './input.dart';
import './medication.dart';

class EditMedication extends StatelessWidget {
  final Medication med = Medication(
    name: '',
    dose: -1,
    leftBehind: false,
    dosageTimes: [],
    history: [],
  );
  bool isSwitched = false;

  List<Medication> medications;

  EditMedication(this.medications);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: Column(
        children: <Widget>[
          Input('Medication Name', med, 'name'),
          Input('Dosage Amount', med, 'amount'),
          Input('Dosage Time', med, 'time'),
          const Text(
            'Left Behind Notification',
            textAlign: TextAlign.center,
          ),
          Switch(
            value: isSwitched,
            onChanged: (value) {
              med.leftBehind = value;
            },
            activeTrackColor: Colors.blueAccent,
            activeColor: Colors.blue,
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              medications.add(med);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              // med.isCancelled is basically a flag that tells us
              // the user cancelled.
              med.isCancelled = true;
              medications.add(med);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
