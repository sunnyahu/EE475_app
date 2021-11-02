import 'package:flutter/material.dart';
import 'package:pill_pal/medication_locate.dart';

import './medication.dart';
import './edit_medication.dart';
import './medication_history.dart';
import './medication_locate.dart';

class MedicationData extends StatefulWidget {
  List<Medication> medications;
  Medication medication;

  MedicationData(this.medications, this.medication);

  @override
  State<StatefulWidget> createState() {
    return MedicationDataState(medications, medication);
  }
}

class MedicationDataState extends State<MedicationData> {
  List<Medication> medications;
  Medication medication;

  MedicationDataState(this.medications, this.medication);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name!),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            child: const Text('Locate Bottle'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocateMedication(),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('View History'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicationHistory(medication),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('View/Edit Information'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMedication(medications, medication),
                ),
              ).then((value) {
                // Reload Home Page once the user enters their medication
                setState(() {});
              });
            },
          ),
          ElevatedButton(
            child: const Text('Delete Bottle'),
            onPressed: () {
              medications.remove(medication);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
