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
import '../../widgets/dosage_select.dart';
import '../../widgets/alert_dialog.dart';
import '../../contact/data/contact.dart';

final GlobalKey<FormState> medicationName = GlobalKey<FormState>();

class EditMedication extends StatefulWidget {
  final List<Medication> medications;
  final List<Contact> contacts;
  final Medication? medication;

  EditMedication(this.medications, this.contacts, this.medication);
  @override
  State<StatefulWidget> createState() {
    return EditMedicationState(medications, contacts, medication);
  }
}

class EditMedicationState extends State<EditMedication> {
  Medication? medication;
  final List<Medication> medications;
  final List<Contact> contacts;
  // "data" is used to keep track of the user responses.
  // Once they click "save", all the information in "data" is copied into the
  // medication object.
  final Map<String, dynamic> data = {};
  late bool isNew;
  // Internally used to check which required fields the user did not fill out.
  List<String> missing = [];

  // Used to display current information entered by the user.
  late String timesString;
  late String startDateString;
  late String endDateString;
  late String contactsString;

  EditMedicationState(this.medications, this.contacts, medication) {
    isNew = medication == null;
    if (isNew) {
      int id = registerBottle();
      this.medication = Medication(id);

      data['dosage'] = 1; // Set 1 as default for dosage.
      data['push'] = false;
      data['left_behind'] = false;

      timesString = "Times";
      startDateString = "Start Date";
      endDateString = "End Date";
      contactsString = "Select Contacts";
    } else {
      this.medication = medication;

      data['name'] = medication.prescription['name'];
      data['dosage'] = medication.prescription['dosage'];
      data['push'] = medication.notificationSettings['push'];
      data['left_behind'] = medication.notificationSettings['left_behind'];

      data['contacts'] = <Contact>[];
      data['contacts'].addAll(medication.notificationSettings['contacts']);
      contactsString =
          data['contacts'].map((contact) => contact.name).join(', ');
      contactsString = "Select Contacts: $contactsString";

      data['times'] = <DateTime>[];
      data['times'].addAll(medication.prescription['times']);
      timesString = data['times'].map((time) {
        return "${time.hour}:${time.minute}${time.minute == 0 ? '0' : ''}";
      }).join(', ');
      timesString = "Times: $timesString";

      DateTime start = medication.prescription['start_date'];
      data['start_date'] = start;
      startDateString = "Start Date: ${start.month}-${start.day}-${start.year}";

      DateTime? end = medication.prescription['end_date'];
      data['end_date'] = end;
      if (end != null) {
        endDateString = "End Date: ${end.month}-${end.day}-${end.year}";
      } else {
        endDateString = "End Date";
      }
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
            isNew ? 'Add Medication' : medication!.prescription['name'],
          ),
        ),
        body: ListView(
          children: <Widget>[
            Input('${!isNew ? "Update " : ""}Prescription/Medication Name',
                data, 'name', false, medicationName),
            ListTile(
              title: Text("Dosage: ${data['dosage']}"),
              leading: const Icon(Icons.medication),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DosageSelect(data, 10, data['dosage']),
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
                    data['times'] = null;
                  });
                },
              ),
              leading: const Icon(Icons.access_time_filled),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeSelect(data),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    List<DateTime> times = data['times'] ??= [];
                    if (times.isNotEmpty) {
                      timesString = times.map((time) {
                        String pad = time.minute == 0 ? '0' : '';
                        return "${time.hour}:${time.minute}$pad";
                      }).join(', ');
                      timesString = "Times: $timesString";
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
                  setState(() {
                    startDateString = "Start Date";
                    data['start_date'] = null;
                  });
                },
              ),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Calendar('Start Date', 'start_date', data),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    if (data['start_date'] != null) {
                      DateTime start = data['start_date'];
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
                  setState(() {
                    endDateString = "End Date";
                    data['end_date'] = null;
                  });
                },
              ),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Calendar('End Date', 'end_date', data),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    if (data['end_date'] != null) {
                      DateTime end = data['end_date'];
                      endDateString =
                          "End Date: ${end.month} ${end.day}-${end.year}";
                    }
                  });
                });
              },
            ),
            ListTile(
              title: Text(
                (data['left_behind'] ? 'Disable' : 'Enable') +
                    ' Bottle Left Behind Notifications',
              ),
              trailing: Icon(
                data['left_behind']
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onTap: () {
                setState(() {
                  data['left_behind'] = !data['left_behind'];
                });
              },
            ),
            ListTile(
              title: Text(
                (data['push'] ? 'Disable' : 'Enable') + ' Push Notifications',
              ),
              trailing: Icon(
                data['push'] ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              onTap: () {
                setState(() {
                  data['push'] = !data['push'];
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
                    builder: (context) => SelectContacts(contacts, data),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    contactsString = data['contacts'].map((contact) {
                      return contact.name;
                    }).join(', ');
                    contactsString = "Select Contacts: $contactsString";
                  });
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                missing.clear();
                Map<String, String> mapping = {
                  'name': 'Name',
                  'times': 'Times',
                  'start_date': 'Start Date'
                };
                // Check if all required fields are filled.
                // dosage is 1 by default.
                // end_date is not required since some patients may have
                // chronic conditions.
                for (final key in ['name', 'times', 'start_date']) {
                  if (data[key] != null) {
                    medication!.prescription[key] = data[key];
                  } else {
                    missing.add(mapping[key]!);
                  }
                }
                medication!.prescription['dosage'] = data['dosage'];
                medication!.prescription['end_date'] = data['end_date'];
                medication!.notificationSettings['left_behind'] =
                    data['left_behind'];
                medication!.notificationSettings['push'] = data['push'];
                medication!.notificationSettings['contacts'] = data['contacts'];

                if (missing.isEmpty) {
                  if (isNew) {
                    // Add medication to list.
                    medications.add(medication!);
                  }
                  Navigator.pop(context);
                } else if (missing.isNotEmpty) {
                  showAlertDialogOkay(context, missing.join(', '));
                }
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
      ),
    );
  }
}
