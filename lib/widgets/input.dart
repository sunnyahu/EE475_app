/// PillPal
///
/// This file stores the Input widgets used on the "Add Medication"
/// and "View/Edit Information" pages to update the Medication information
/// through textfields and buttons.

// Code from Flutter Docs:
// https://api.flutter.dev/flutter/widgets/Form-class.html

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

class Input extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String text;
  final Medication medication;
  final String id;

  Input(this.text, this.medication, this.id);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onSaved: (value) => medication.set(id, value),
              decoration: InputDecoration(
                hintText: text,
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                    _formKey.currentState!.save();
                  }
                },
                child: const Text(
                  'Submit',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
