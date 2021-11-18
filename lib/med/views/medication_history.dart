/// PillPal
///
/// This file stores the "View History" for a given medication,
/// showing when the medication was taken.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

class MedicationHistory extends StatelessWidget {
  Medication medication;

  MedicationHistory(this.medication);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.prescription['name']),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: medication.history['dosage'].length,
                itemBuilder: (BuildContext context, int index) {
                  var history = medication.history[index];
                  return ListTile(
                    title: Text(
                      '${history.day}/${history.month}/${history.year}',
                    ),
                    subtitle: Text(medication.history[index].time),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
