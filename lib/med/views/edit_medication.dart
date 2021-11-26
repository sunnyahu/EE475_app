/// PillPal
///
/// This file stores the "Add/Edit Medication" page which appears when
/// the user clicks the button in the bottom right of the home page
/// to add a new medication, or when they click on "Edit/View Information"
/// on a specific medication.
///

import 'package:flutter/material.dart';
import 'package:pill_pal/contact/views/select_contacts.dart';
import 'package:pill_pal/widgets/calendar.dart';

import '../../blue/services/register_bottle.dart';
import '../../med/data/medication.dart';
import '../../widgets/input.dart';
import '../../widgets/calendar.dart';
import '../../widgets/time_select.dart';
import '../../widgets/number_select.dart';
import '../../widgets/alert_dialog.dart';
import '../../contact/data/contact.dart';
import '../../db/database.dart';

final GlobalKey<FormState> medicationName = GlobalKey<FormState>();

@immutable
class EditMedication extends StatefulWidget {
  final List<Medication> medications;
  final List<Contact> contacts;
  final Medication? medication;

  const EditMedication({
    Key? key,
    required this.medications,
    required this.contacts,
    required this.medication,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      EditMedicationState(medications, contacts, medication);
}

class EditMedicationState extends State<EditMedication> {
  late Medication originalMedication;
  Medication? medication;
  final List<Medication> medications;
  final List<Contact> contacts;
  // If the user is adding a new medication "isNew" is true.
  late bool isNew;

  // Used to display current information entered by the user.
  late String timesString;
  late String startDateString;
  late String endDateString;
  late String contactsString;

  EditMedicationState(this.medications, this.contacts, medication) {
    isNew = medication == null;
    if (isNew) {
      registerBottle(medications).then((value) {
        print("======================Received bottle id: " + value.toString());
        this.medication = Medication(value);
      });
      print("after registerbottle");

      timesString = "Times";
      startDateString = "Start Date";
      endDateString = "End Date";
      contactsString = "Select Contacts";
    } else {
      // Save original state of the medication. In case the user cancels the
      // changes, we can revert to this state.
      originalMedication = medication.copy();
      this.medication = medication;

      timesString = "Times: ${medication.times.map((time) {
        return "${time.hour}:${time.minute}${time.minute == 0 ? '0' : ''}";
      }).join(', ')}";

      DateTime? start = medication.startDate;
      startDateString = start == null
          ? "Start Date"
          : "Start Date: ${start.day}/${start.month}/${start.year}";
      DateTime? end = medication.endDate;
      endDateString = end == null
          ? "End Date"
          : "End Date: ${end.month}-${end.day}-${end.year}";
      contactsString =
          "Select Contacts: ${medication.contacts.map((contact) => contact.name).join(', ')}";
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
            isNew ? 'Add Medication' : medication!.name!,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Input(
              text:
                  '${!isNew ? "Update " : ""}Prescription/Medication Name', // Textfield label.
              object: medication!, // Medication object to modify.
              dataKey: 'name', // Field name in Medication object to modify.
              isPhone: false, // Does the field use a phone keyboard?
              formKey: medicationName, // Form key.
            ),
            ListTile(
              title: Text("Dosage: ${medication!.dosage}"),
              leading: const Icon(Icons.medication),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberSelect(
                      medication: medication!, // Medication object to modify.
                      count: 10, // Number of choices, goes from 1-10.
                      keyName: 'dosage', // Field name in Medication to modify.
                      text: 'Dosage', // Page Title Name.
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: Text(timesString),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.red,
                tooltip: 'Remove Times',
                splashRadius: 20,
                onPressed: () {
                  setState(() {
                    timesString = "Times";
                    medication!.times.clear();
                  });
                },
              ),
              leading: const Icon(Icons.access_time_filled),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeSelect(medication: medication!),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    List<DateTime> times = medication!.times;
                    if (times.isNotEmpty) {
                      timesString = "Times: ${times.map((time) {
                        String pad = time.minute == 0 ? '0' : '';
                        return "${time.hour}:${time.minute}$pad";
                      }).join(', ')}";
                    }
                  });
                });
              },
            ),
            ListTile(
              title: Text(startDateString),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.red,
                tooltip: 'Remove Start Date',
                splashRadius: 20,
                onPressed: () {
                  medication!.startDate = null;
                  setState(() {
                    startDateString = "Start Date";
                  });
                },
              ),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Calendar(
                      text: 'Start Date',
                      date: 'startDate', // Field name in medication object.
                      medication: medication!,
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    DateTime? start = medication!.startDate;
                    if (start != null) {
                      startDateString =
                          "Start Date: ${start.month}-${start.day}-${start.year}";
                    }
                  });
                });
              },
            ),
            ListTile(
              title: Text(endDateString),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.red,
                tooltip: 'Remove End Date',
                splashRadius: 20,
                onPressed: () {
                  medication!.endDate = null;
                  setState(() {
                    endDateString = "End Date";
                  });
                },
              ),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Calendar(
                      text: 'End Date',
                      date: 'endDate', // Field name in medication object.
                      medication: medication!,
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    DateTime? end = medication!.endDate;
                    if (end != null) {
                      endDateString =
                          "End Date: ${end.month}-${end.day}-${end.year}";
                    }
                  });
                });
              },
            ),
            ListTile(
              title: Text('Every ${medication!.xDays} Days'),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberSelect(
                      medication: medication!, // Medication object to modify.
                      count: 30, // Number of choices, goes from 1-30.
                      keyName: 'xDays', // Field name in Medication to modify.
                      text: 'X Days', // Page Title Name.
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: Text(
                (medication!.leftBehind ? 'Disable' : 'Enable') +
                    ' Bottle Left Behind Notifications',
              ),
              trailing: Icon(
                medication!.leftBehind
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onTap: () {
                setState(() {
                  medication!.leftBehind = !medication!.leftBehind;
                });
              },
            ),
            ListTile(
              title: Text(
                (medication!.push ? 'Disable' : 'Enable') +
                    ' Push Notifications',
              ),
              trailing: Icon(
                medication!.push
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onTap: () {
                setState(() {
                  medication!.push = !medication!.push;
                });
              },
            ),
            ListTile(
              title: Text(contactsString),
              leading: const Icon(Icons.contacts),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectContacts(
                      contacts: contacts,
                      medication: medication!,
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    contactsString =
                        "Select Contacts: ${medication!.contacts.map((contact) {
                      return contact.name;
                    }).join(', ')}";
                  });
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (medication!.isValid) {
                  if (isNew) {
                    // Add medication to list.
                    medications.add(medication!);
                  }
                  // Save medication to file.
                  write(
                    MEDICATIONS_DB,
                    {
                      'medications':
                          medications.map((m) => m.toJson()).toList(),
                    },
                  );
                  Navigator.pop(context);
                } else {
                  showAlertDialogOkay(
                    context,
                    "Missing ${medication!.missing}",
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Reset the medication to it's original state.
                if (!isNew) {
                  medication!.copyFrom(originalMedication);
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
