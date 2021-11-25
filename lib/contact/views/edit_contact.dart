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

// Keys for the form fields (text inputs).
final GlobalKey<FormState> contactName = GlobalKey<FormState>();
final GlobalKey<FormState> phoneNumber = GlobalKey<FormState>();

@immutable
class EditContact extends StatefulWidget {
  final List<Contact> contacts;
  final Contact? contact;

  const EditContact(this.contacts, this.contact, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return EditContactState(contacts, contact);
  }
}

class EditContactState extends State<EditContact> {
  late Contact originalContact;
  Contact? contact;
  final List<Contact> contacts;

  late bool isNew;

  EditContactState(this.contacts, contact) {
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
            Input('${!isNew ? "Update " : ""}Contact Name', contact, 'name',
                false, contactName),
            Input('Phone Number', contact, 'phoneNumber', true, phoneNumber),
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
                    contacts.add(contact!);
                  }
                  Navigator.pop(context);
                } else {
                  showAlertDialogOkay(context, contact!.missing);
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
