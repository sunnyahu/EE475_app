import 'package:flutter/material.dart';
import 'package:pill_pal/db/database.dart';

import '../../med/data/medication.dart';
import '../../contact/data/contact.dart';

// Shows an alert dialog to tell user to enter required information.
// Only used as a notifier with an "Okay" button.
// Only used in the "edit_medication.dart" file.
showAlertDialogOkay(BuildContext context, String message) {
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
    title: const Text('Error'),
    content: Text(message),
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

// Shows an alert dialog to confirm the deletion of an Object from a list with
// "Yes" or "No" options.
// Only used in the "medication_data.dart" and "edit_contact.dart" files.
showAlertDialogYesNo(
  String headerText,
  String descriptionText,
  BuildContext context,
  List<Medication> medications,
  List<Contact> contacts,
  Object object,
) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text('No'),
    onPressed: () {
      // Close the dialog window.
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text('Yes'),
    onPressed: () {
      if (headerText.endsWith('Medication')) {
        medications.remove(object);
        write(
          MEDICATIONS_DB,
          {'medications': medications.map((m) => m.toJson()).toList()},
        );
      } else if (headerText.endsWith('Contact')) {
        contacts.remove(object);
        write(
          CONTACTS_DB,
          {'contacts': contacts.map((c) => c.toJson()).toList()},
        );
        // If contact was deleted, we delete them from every medication.
        for (Medication m in medications) {
          for (Contact c in m.contacts) {
            if (c.id == (object as Contact).id) {
              m.contacts.remove(c);
              break;
            }
          }
        }
      }
      // Close the dialog window.
      Navigator.of(context, rootNavigator: true).pop();
      // Close the current page since the user just deleted this object.
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(headerText),
    content: Text(descriptionText),
    actions: [
      continueButton,
      cancelButton,
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
