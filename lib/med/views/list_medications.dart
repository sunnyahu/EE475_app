/// PillPal
///
/// This file stores the List Medications page for the PillPal App which displays
/// all the medications the user has entered.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';
import '../../med/views/edit_medication.dart';
import '../../med/views/medication_data.dart';
import '../../contact/data/contact.dart';

@immutable
class ListMedications extends StatefulWidget {
  final List<Medication> medications;
  final List<Contact> contacts;

  const ListMedications({
    Key? key,
    required this.medications,
    required this.contacts,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      ListMedicationState(medications, contacts);
}

class ListMedicationState extends State<ListMedications> {
  // List of Medications
  final List<Medication> medications;
  final List<Contact> contacts;

  ListMedicationState(this.medications, this.contacts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
      ),
      body: Column(
        children: <Widget>[
          // List of Medications Entered by the user.
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: medications.length,
              itemBuilder: (BuildContext context, int index) {
                Medication medication = medications[index];
                return ListTile(
                  title: Text(medication.name!),
                  subtitle: Text('ID: ' + medication.id.toString()),
                  trailing: const Icon(Icons.medical_services),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicationData(
                          medications: medications,
                          contacts: contacts,
                          medication: medication,
                        ),
                      ),
                    ).then((value) {
                      // Reload Home Page once the user enters their medication.
                      setState(() {});
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // scan_new_bottle.dart view
              builder: (context) => EditMedication(
                medications: medications,
                contacts: contacts,
                medication: null,
              ),
            ),
          ).then((value) {
            // Reload Home Page once the user enters their medication.
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Add Medication',
      ),
    );
  }
}
