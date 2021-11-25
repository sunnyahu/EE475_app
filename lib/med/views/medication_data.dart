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
import '../../med/views/edit_medication.dart';
import '../../med/views/medication_history.dart';
import '../../blue/views/medication_locate.dart';
import '../../widgets/alert_dialog.dart';
import '../../contact/data/contact.dart';

@immutable
class MedicationData extends StatefulWidget {
  final List<Medication> medications;
  final List<Contact> contacts;
  final Medication medication;

  const MedicationData(this.medications, this.contacts, this.medication,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MedicationDataState(medications, contacts, medication);
  }
}

class MedicationDataState extends State<MedicationData> {
  List<Medication> medications;
  List<Contact> contacts;
  Medication medication;

  MedicationDataState(this.medications, this.contacts, this.medication);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.get('name')),
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
                  builder: (context) => LocateMedication(medication),
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
                  builder: (context) =>
                      EditMedication(medications, contacts, medication),
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
              showAlertDialogYesNo(
                "Delete Medication",
                "Are you sure you want to delete this medication?",
                context,
                medications,
                medication,
              );
            },
          ),
        ],
      ),
    );
  }
}
