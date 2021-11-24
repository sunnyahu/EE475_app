/// PillPal
///
/// This file stores the Select Contacts page for the PillPal App which displays
/// allows the user to select which contacts should be notified on the\
/// "Edit Medication" screen.

import 'package:flutter/material.dart';

import '../../contact/data/contact.dart';
import '../../med/data/medication.dart';

class SelectContacts extends StatefulWidget {
  List<Contact> contacts;
  Medication medication;
  @override
  SelectContacts(this.contacts, this.medication);

  State<StatefulWidget> createState() {
    return SelectContactsState(contacts, medication);
  }
}

class SelectContactsState extends State<SelectContacts> {
  // List of Medications
  List<Contact> contacts;
  Medication medication;

  SelectContactsState(this.contacts, this.medication);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts'),
      ),
      body: Column(
        children: <Widget>[
          // List of Contacts Entered by the user.
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.name!),
                  subtitle: Text(contact.phoneNumber!),
                  trailing: Icon(
                    medication.contacts.contains(contact)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  onTap: () {
                    setState(() {
                      if (medication.contacts.contains(contact)) {
                        medication.contacts.remove(contact);
                      } else {
                        medication.contacts.add(contact);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
