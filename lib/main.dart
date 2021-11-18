/// PillPal
///
/// This file stores the home page for the PillPal App which displays
/// all the medications the user has entered.

import 'package:flutter/material.dart';

import './med/data/medication.dart';
import './med/views/edit_medication.dart';
import './med/views/medication_data.dart';
import './widgets/header_text.dart';

void main() {
  runApp(MaterialApp(
    home: PillPal(),
  ));
}

class PillPal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PillPalState();
  }
}

class PillPalState extends State<PillPal> {
  // List of Medications
  List<Medication> medications = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PillPal'),
        ),
        body: Column(
          children: <Widget>[
            HeaderText('Medications'),
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
                    trailing: const Icon(Icons.medical_services),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MedicationData(medications, medication),
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
                builder: (context) => EditMedication(medications, null),
              ),
            ).then((value) {
              // Reload Home Page once the user enters their medication.
              setState(() {});
            });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
