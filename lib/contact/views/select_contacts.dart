/// PillPal
///
/// This file stores the List Contacts page for the PillPal App which displays
/// all the contacts the user has entered.

import 'package:flutter/material.dart';

import '../../contact/data/contact.dart';

class SelectContacts extends StatefulWidget {
  List<Contact> contacts;
  Map<String, dynamic> data;
  @override
  SelectContacts(this.contacts, this.data);

  State<StatefulWidget> createState() {
    return SelectContactsState(contacts, data);
  }
}

class SelectContactsState extends State<SelectContacts> {
  // List of Medications
  List<Contact> contacts;
  Map<String, dynamic> data;
  late List<Contact> selectedContacts;

  SelectContactsState(this.contacts, this.data) {
    if (data['contacts'] == null) {
      data['contacts'] = <Contact>[];
    }
    selectedContacts = data['contacts'];
  }

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
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber),
                  trailing: Icon(
                    selectedContacts.contains(contact)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  onTap: () {
                    setState(() {
                      if (selectedContacts.contains(contact)) {
                        selectedContacts.remove(contact);
                      } else {
                        selectedContacts.add(contact);
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
