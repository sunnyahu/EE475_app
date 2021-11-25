/// PillPal
///
/// This file stores the "View History" for a given medication,
/// showing when the medication was taken.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

class MedicationHistory extends StatelessWidget {
  final Medication medication;

  const MedicationHistory(this.medication, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name!),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: medication.dosageHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  var history = medication.dosageHistory[index];
                  return ListTile(
                    title: Text(
                      '${history.day}/${history.month}/${history.year}',
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
