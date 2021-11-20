/// PillPal
///
/// This file stores the Input widgets used on the "Add Medication"
/// and "View/Edit Information" pages to update the Medication information
/// through textfields and buttons.

// Code from Flutter Docs:
// https://api.flutter.dev/flutter/widgets/Form-class.html

import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String text;
  final Map<String, dynamic> data;
  final String dataKey;
  final bool isPhone;

  Input(this.text, this.data, this.dataKey, this.isPhone, this.formKey);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              // Different keyboards for different data types (phone number vs text)
              keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
              onSaved: (value) {
                data[dataKey] = value;
              },
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
                  if (formKey.currentState!.validate()) {
                    // Process data.
                    formKey.currentState!.save();
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
