/// PillPal
///
/// This file stores the home page for the PillPal App which displays
/// all the medications the user has entered.

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/services/scanner_task.dart';
import 'package:pill_pal/notifications/services/notifs.dart';

import '../../med/data/medication.dart';
import '../../med/views/list_medications.dart';
import '../../contact/data/contact.dart';
import '../../contact/views/list_contacts.dart';
import '../../db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initNotifications();
  FlutterBackgroundService.initialize(startScanner);

  runApp(const MaterialApp(
    home: PillPal(),
  ));
}

@immutable
class PillPal extends StatefulWidget {
  const PillPal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PillPalState();
}

class PillPalState extends State<PillPal> {
  // List of Medications.
  List<Medication> medications = [];
  // List of Contacts.
  List<Contact> contacts = [];
  String text = "Stop Scanning Service";

  @override
  void initState() {
    super.initState();
    // Load medications from json file.
    read(MEDICATIONS_DB).then((json) {
      setState(() {
        if (json.isEmpty) {
          medications = [];
        } else {
          medications = json['medications']
              .map<Medication>((m) => Medication.fromJson(m))
              .toList();
        }
      });
      List<int> mIds = [];
      for (var m in medications) {
        mIds.add(m.id);
      }
      FlutterBackgroundService().sendData({"ids": mIds});
    });
    // Load contacts from json file.
    read(CONTACTS_DB).then((json) {
      setState(() {
        if (json.isEmpty) {
          contacts = [];
        } else {
          contacts = json['contacts']
              .map<Contact>((c) => Contact.fromJson(c))
              .toList();
        }
      });
    });

    // set up a listener for backend changes
    FlutterBackgroundService().onDataReceived.listen((snapshot) {
      if (snapshot!.containsKey('updated_med_state')) {
        Medication m = Medication.fromJson(snapshot['updated_med_state']);
        for (int i = 0; i < medications.length; i++) {
          if (medications[i].id == m.id) {
            medications[i].seqNum = m.seqNum;
            medications[i].nPills = m.nPills;
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('PillPal'),
          ),
          body: Column(
            children: [
              ListTile(
                title: const Text("Medications"),
                trailing: const Icon(Icons.medication),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListMedications(
                        medications: medications,
                        contacts: contacts,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Contacts"),
                trailing: const Icon(Icons.contacts),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListContacts(
                        medications: medications,
                        contacts: contacts,
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: Text(text),
                onPressed: () async {
                  var isRunning =
                      await FlutterBackgroundService().isServiceRunning();
                  if (isRunning) {
                    FlutterBackgroundService().sendData(
                      {"action": "stopService"},
                    );
                  } else {
                    FlutterBackgroundService.initialize(startScanner);
                  }
                  if (!isRunning) {
                    text = 'Stop Scanning Service';
                  } else {
                    text = 'Start Scanning Service';
                  }
                  setState(() {});
                },
              ),
            ],
          )),
    );
  }
}
