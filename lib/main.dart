import 'package:flutter/material.dart';

import './medication.dart';
import './header_text.dart';
import './edit_medication.dart';
import './medication_data.dart';

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
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (BuildContext context, int index) {
                  Medication medication = medications[index];
                  return ElevatedButton(
                    child: Text(medication.name!),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MedicationData(medications, medication),
                        ),
                      ).then((value) {
                        // Reload Home Page once the user enters their medication
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
              // Reload Home Page once the user enters their medication
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
