/// PillPal
///
/// This file stores the home page for the PillPal App which displays
/// all the medications the user has entered.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';
import '../../med/views/list_medications.dart';
import '../../contact/data/contact.dart';
import '../../contact/views/list_contacts.dart';
import '../../db/database.dart';

void main() {
  runApp(const MaterialApp(
    home: PillPal(),
  ));
}

@immutable
class PillPal extends StatefulWidget {
  const PillPal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PillPalState();
}

class PillPalState extends State<PillPal> {
  // List of Medications.
  List<Medication> medications = [];
  // List of Contacts.
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    read(MEDICATIONS_DB).then((json) {
      setState(() {
        if (json.isEmpty) {
          medications = [];
        } else {
          medications = json['medications']
              .map<Medication>((m) => Medication.fromJson(m))
              .toList();
        }
      });
    });
    read(CONTACTS_DB).then((json) {
      setState(() {
        if (json.isEmpty) {
          contacts = [];
        } else {
          contacts = json['contacts']
              .map<Contact>((c) => Contact.fromJson(c))
              .toList();
        }
      });
    });
  }

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
                      builder: (context) => ListMedications(
                        medications: medications,
                        contacts: contacts,
                      ),
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
                      builder: (context) => ListContacts(
                        medications: medications,
                        contacts: contacts,
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
