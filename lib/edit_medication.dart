// The "Add Medication Page"
// Opens when the user clicks the add button in the buttom right of the
// main page.

import 'package:flutter/material.dart';

import './input.dart';
import './medication.dart';

class EditMedication extends StatelessWidget {
  bool isSwitched = false;

  List<Medication> medications;
  Medication? medication;
  // "isNew" is true if the user is adding a new medication.
  bool isNew = true;

  EditMedication(this.medications, medication) {
    isNew = medication == null;
    if (isNew) {
      this.medication = Medication();
    } else {
      this.medication = medication;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNew ? 'Add Medication' : '${medication!.name} Medication',
        ),
      ),
      body: Column(
        children: <Widget>[
          Input('Medication Name', medication!, 'name'),
          Input('Dosage Amount', medication!, 'amount'),
          Input('Dosage Time', medication!, 'time'),
          const Text(
            'Left Behind Notification',
            textAlign: TextAlign.center,
          ),
          Switch(
            value: isSwitched,
            onChanged: (value) {
              medication!.leftBehind = value;
            },
            activeTrackColor: Colors.blueAccent,
            activeColor: Colors.blue,
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              if (isNew) {
                medications.add(medication!);
              }
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
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
}
