/// PillPal
///
/// This file stores the "Add/Edit Medication" page which appears when
/// the user clicks the button in the bottom right of the home page
/// to add a new medication, or when they click on "Edit/View Information"
/// on a specific medication.
///

import 'package:flutter/material.dart';

import '../../widgets/input.dart';
import '../../contact/data/contact.dart';
import '../../widgets/alert_dialog.dart';

class EditContact extends StatefulWidget {
  final List<Contact> contacts;
  final Contact? contact;

  EditContact(this.contacts, this.contact);
  @override
  State<StatefulWidget> createState() {
    return EditContactState(contacts, contact);
  }
}

class EditContactState extends State<EditContact> {
  Contact? contact;
  final List<Contact> contacts;
  // "data" is used to keep track of the user responses.
  // Once they click "save", all the information in "data" is copied into the
  // medication object.
  final Map<String, dynamic> data = {};
  late bool isNew;
  // Internally used to check which required fields the user did not fill out.
  List<String> missing = [];

  EditContactState(this.contacts, contact) {
    isNew = contact == null;
    if (isNew) {
      this.contact = Contact();
    } else {
      this.contact = contact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          isNew ? 'Add Contact' : contact!.name,
        ),
      ),
      body: Column(
        children: <Widget>[
          Input('${!isNew ? "Update " : ""}Contact Name', data, 'name', false),
          Input('Phone Number', data, 'phone_number', true),
          ListTile(
            title: const Text('Delete Contact'),
            enabled: !isNew,
            trailing: const Icon(Icons.delete),
            onTap: () {
              showAlertDialogYesNo(
                "Delete Contact",
                "Are you sure you want to delete this contact?",
                context,
                contacts,
                contact!,
              );
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Shows an alert dialog to tell user to enter required information.
  showAlertDialog(BuildContext context, String message) {
    // set up the buttons
    Widget okayButton = TextButton(
      child: const Text('Okay'),
      onPressed: () {
        // Close the dialog window.
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Missing Required Information'),
      content: Text('Missing: $message'),
      actions: [
        okayButton,
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
