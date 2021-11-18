/// PillPal
///
/// This file stores the "Medication Data" page
/// which has the following components:
/// - Locate Bottle Button
/// - View History Button
/// - View/Edit Information Button
/// - Delete Medication Button

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';
import './edit_medication.dart';
import './medication_history.dart';
import '../../blue/views/medication_locate.dart';

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
          ListTile(
            title: const Text('Locate Bottle'),
            trailing: const Icon(Icons.add_location_sharp),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocateMedication(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('View History'),
            trailing: const Icon(Icons.history),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicationHistory(medication),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('View/Edit Information'),
            trailing: const Icon(Icons.edit),
            onTap: () {
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
          const Divider(),
          ListTile(
            title: const Text('Delete Medication'),
            trailing: const Icon(Icons.delete),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Shows an alert dialog to confirm the deletion of the medication.
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('No'),
      onPressed: () {
        // Close the dialog window.
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text('Yes'),
      onPressed: () {
        medications.remove(medication);
        // Close the dialog window.
        Navigator.of(context, rootNavigator: true).pop();
        // Close the current page since the user just deleted this medication.
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Delete Medication'),
      content: const Text(
        'Are you sure you want to delete this medication?',
      ),
      actions: [
        continueButton,
        cancelButton,
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
