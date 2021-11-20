/// PillPal
///
/// This file stores the home page for the PillPal App which displays
/// all the medications the user has entered.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';
import '../../med/views/list_medications.dart';
import '../../contact/data/contact.dart';
import '../../contact/views/list_contacts.dart';

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
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('PillPal'),
          ),
          body: Column(
            children: [
              ListTile(
                title: const Text("Medications"),
                trailing: const Icon(Icons.medication),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ListMedications(medications, contacts),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Contacts"),
                trailing: const Icon(Icons.contacts),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListContacts(contacts),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
