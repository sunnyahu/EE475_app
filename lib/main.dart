/// PillPal
///
/// This file stores the home page for the PillPal App which displays
/// all the medications the user has entered.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';
import '../../med/views/list_medications.dart';
import '../../contact/data/contact.dart';
import '../../contact/views/list_contacts.dart';

void main() {
  runApp(MaterialApp(
    home: PillPal(),
  ));
}

class PillPal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PillPalState();
  }
}

class PillPalState extends State<PillPal> {
  // List of Medications
  List<Medication> medications = [];
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    int index = 0;
    PageController pageController = PageController(initialPage: 0);
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (int page) {
            setState(() {
              index = page;
            });
          },
          children: <Widget>[
            ListMedication(medications),
            ListContacts(contacts),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
          ],
          onTap: (int page) {
            pageController.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }
}
