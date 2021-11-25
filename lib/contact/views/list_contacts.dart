/// PillPal
///
/// This file stores the List Contacts page for the PillPal App which displays
/// all the contacts the user has entered.

import 'package:flutter/material.dart';

import '../../contact/data/contact.dart';
import '../../contact/views/edit_contact.dart';

@immutable
class ListContacts extends StatefulWidget {
  final List<Contact> contacts;

  const ListContacts(this.contacts, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListContactsState(contacts);
  }
}

class ListContactsState extends State<ListContacts> {
  // List of Medications
  List<Contact> contacts;

  ListContactsState(this.contacts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
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
                  trailing: const Icon(Icons.person),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContact(contacts, contact),
                      ),
                    ).then((value) {
                      // Reload Home Page once the user enters a contact.
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
              builder: (context) => EditContact(contacts, null),
            ),
          ).then((value) {
            // Reload Home Page once the user enters their medication.
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
