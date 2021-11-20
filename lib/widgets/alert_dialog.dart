import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

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

// Shows an alert dialog to confirm the deletion of an Object from a list with
// "Yes" or "No" options.
// Only used in the "medication_data.dart" and "edit_contact.dart" files.
showAlertDialogYesNo(
  String headerText,
  String descriptionText,
  BuildContext context,
  List<Object> objects,
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
      objects.remove(object);
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
