/// PillPal
///
/// This file stores the "Add/Edit Medication" page which appears when
/// the user clicks the button in the bottom right of the home page
/// to add a new medication, or when they click on "Edit/View Information"
/// on a specific medication.
///

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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
  final Medication? medication;
  final List<Medication> medications;
  final List<Contact> contacts;
  // If the user is adding a new medication "isNew" is true.
  late bool isNew;
  // Intermediate Medication Object to store the user's input/changes.
  late Medication data;

  final nameController = TextEditingController();
  final doseController = TextEditingController();
  final cntController = TextEditingController();

  // Used to display current information entered by the user.
  late String timesString;
  late String startDateString;
  late String endDateString;
  late String contactsString;

  EditMedicationState(this.medications, this.contacts, this.medication) {
    isNew = medication == null;
    if (isNew) {
      data = Medication(-1);
      registerBottle(medications).then((value) {
        print("======================Received bottle id: " + value.toString());
        data.id = value;
      });

      timesString = "Times";
      startDateString = "Start Date";
      endDateString = "End Date";
      contactsString = "Select Contacts";
      nameController.text = "New Medication";
      cntController.text = "0";
      doseController.text = "1";
    } else {
      // Save original state of the medication. In case the user cancels the
      // changes, we can revert to this state.
      data = medication!.copy();

      timesString = "Times: ${data.times.map((time) {
        return "${time.hour}:${time.minute < 10 ? '0' + time.minute.toString() : time.minute.toString()}";
      }).join(', ')}";

      DateTime? start = data.startDate;
      startDateString = start == null
          ? "Start Date"
          : "Start Date: ${start.day}-${start.month}-${start.year}";
      DateTime? end = data.endDate;
      endDateString = end == null
          ? "End Date"
          : "End Date: ${end.month}-${end.day}-${end.year}";
      contactsString =
          "Select Contacts: ${data.contacts.map((contact) => contact.name).join(', ')}";
      nameController.text = medication!.name!;
      cntController.text = medication!.nPills.toString();
      doseController.text = medication!.dosage.toString();
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
            isNew ? 'Add Medication' : data.name!,
          ),
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              // text input for name
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (value) {
                data.name = value;
                setState(() {});
              },
            ),
            TextField(
                // input for total number of pills
                controller: cntController,
                decoration:
                    const InputDecoration(labelText: "Total Number of Pills"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value == "") {
                    data.nPills = 0;
                  } else {
                    data.nPills = num.tryParse(value)!.toInt();
                  }
                  setState(() {});
                }),
            TextField(
                // input for dosage amount (number of pills per bottle open)
                controller: doseController,
                decoration: const InputDecoration(labelText: "Dosage Amount"),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  if (value == "") {
                    data.dosage = 0;
                  } else {
                    data.dosage = num.tryParse(value)!.toInt();
                  }
                  setState(() {});
                }),
            ListTile(
              // list of times of the day to take the medicine
              title: Text(timesString),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.red,
                tooltip: 'Remove Times',
                splashRadius: 20,
                onPressed: () {
                  setState(() {
                    timesString = "Times";
                    data.times.clear();
                  });
                },
              ),
              leading: const Icon(Icons.access_time_filled),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeSelect(medication: data),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    List<DateTime> times = data.times;
                    if (times.isNotEmpty) {
                      timesString =
                          "Times: ${times.map((t) => "${t.hour}:${t.minute < 10 ? "0" + t.minute.toString() : t.minute.toString()}").join(', ')}";
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
                  data.startDate = null;
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
                      medication: data,
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    DateTime? start = data.startDate;
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
                  data.endDate = null;
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
                      medication: data,
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    DateTime? end = data.endDate;
                    if (end != null) {
                      endDateString =
                          "End Date: ${end.month}-${end.day}-${end.year}";
                    }
                  });
                });
              },
            ),
            ListTile(
              title: Text('Every ${data.xDays} Days'),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberSelect(
                      medication: data, // Medication object to modify.
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
                (data.leftBehind ? 'Disable' : 'Enable') +
                    ' Bottle Left Behind Notifications',
              ),
              trailing: Icon(
                data.leftBehind
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onTap: () {
                setState(() {
                  data.leftBehind = !data.leftBehind;
                });
              },
            ),
            ListTile(
              title: Text(
                (data.push ? 'Disable' : 'Enable') + ' Push Notifications',
              ),
              trailing: Icon(
                data.push ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              onTap: () {
                setState(() {
                  data.push = !data.push;
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
                      medication: data,
                    ),
                  ),
                ).then((value) {
                  // Reload Page.
                  setState(() {
                    contactsString =
                        "Select Contacts: ${data.contacts.map((contact) {
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
                if (data.id != -1) {
                  if (data.isValid) {
                    data.times.add(DateTime.now()
                        .add(const Duration(minutes: 1, seconds: 30)));
                    if (isNew) {
                      // Add medication to list.
                      medications.add(data);
                      // add a record for a brand new log
                      FlutterBackgroundService().sendData({
                        "ids": [data.id]
                      });
                    } else {
                      medication!.copyFrom(data);
                    }
                    FlutterBackgroundService().sendData({'updated_med': data});
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
                      "Missing ${data.missing}",
                    );
                  }
                } else {
                  showAlertDialogOkay(
                    context,
                    "Could not pair with a bottle.",
                  );
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
