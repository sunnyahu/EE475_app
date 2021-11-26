/// PillPal
///
/// This file stores the "Add/Edit Medication" page which appears when
/// the user clicks the button in the bottom right of the home page
/// to add a new medication, or when they click on "Edit/View Information"
/// on a specific medication.
///

import 'package:flutter/material.dart';
import 'package:pill_pal/db/database.dart';

import '../../widgets/input.dart';
import '../../contact/data/contact.dart';
import '../../widgets/alert_dialog.dart';
import '../../med/data/medication.dart';

// Keys for the form fields (text inputs).
final GlobalKey<FormState> contactName = GlobalKey<FormState>();
final GlobalKey<FormState> phoneNumber = GlobalKey<FormState>();

@immutable
class EditContact extends StatefulWidget {
  final List<Medication> medications;
  final List<Contact> contacts;
  final Contact? contact;

  const EditContact({
    Key? key,
    required this.medications,
    required this.contacts,
    required this.contact,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => EditContactState(
        medications,
        contacts,
        contact,
      );
}

class EditContactState extends State<EditContact> {
  final List<Medication> medications;
  late Contact originalContact;
  Contact? contact;
  final List<Contact> contacts;

  late bool isNew;

  EditContactState(this.medications, this.contacts, contact) {
    isNew = contact == null;
    if (isNew) {
      this.contact = Contact();
    } else {
      originalContact = contact.copy();
      this.contact = contact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Required so that textfields lose focus when you click outside of them.
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            isNew
                ? 'Add Contact'
                : '${contact!.name} - ${contact!.phoneNumber}',
          ),
        ),
        body: ListView(
          children: <Widget>[
            Input(
              text: '${!isNew ? "Update " : ""}Contact Name', // Page Title
              object: contact, // Contact to update.
              dataKey: 'name', // Field to update.
              isPhone: false, // Keyboard type is phone input.
              formKey: contactName, // Key for form field.
            ),
            Input(
              text: 'Phone Number', // Page Title.
              object: contact, // Contact to update.
              dataKey: 'phoneNumber', // Field to update.
              isPhone: true, // Keyboard type is text input.
              formKey: phoneNumber, // Key for form field.
            ),
            isNew
                ? const SizedBox.shrink()
                : ListTile(
                    tileColor: Colors.red,
                    title: const Text(
                      'Delete Contact',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.delete, color: Colors.white),
                    onTap: () {
                      showAlertDialogYesNo(
                        "Delete Contact",
                        "Are you sure you want to delete this contact?",
                        context,
                        medications,
                        contacts,
                        contact!,
                      );
                    },
                  ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (contact!.isValid) {
                  if (isNew) {
                    // Check if contact exists by checking id.
                    if (contacts.where((c) => c.id == contact!.id).isNotEmpty) {
                      showAlertDialogOkay(
                        context,
                        "This contact already exists.",
                      );
                      return;
                    }
                    contacts.add(contact!);
                  }
                  write(
                    CONTACTS_DB,
                    {'contacts': contacts.map((c) => c.toJson()).toList()},
                  );
                  Navigator.pop(context);
                } else {
                  showAlertDialogOkay(
                    context,
                    "Missing: ${contact!.missing}",
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                if (!isNew) {
                  contact!.copyFrom(originalContact);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
