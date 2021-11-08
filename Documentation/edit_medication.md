# EditMedication

The `MedicationData` class is in the `edit_medication.dart` file.

The `EditMedication` class is the page of the app that looks like this:

<img src="Documentation/Pages/EditMedication.png" alt="EditMedication page" width=50% />

## Structure

```dart
Scaffold(
    // "appBar" is the "Title" seen at the top of the page.
    appBar: // Medication Name if Medication is being Edited, otherwise just "Medication" 
    // "body" contains all the elements in this page as a list of Widgets.
    body: Column(
        // The "Input" object represents both the textfield and the "Submit" button.
        // It takes three inputs, described below.
        //      Textfield Text: The text that appears in the text field
        //      Medication Object: The current medication object being edited/created.
        //      Field name: The field name of the field in the Medication object that will be updated/added.
        //                  Check the Medication object "set" function in "Medication.dart"
        Input("Textfield Text", "Medication Object", "Field name"), // Medication Name Input.
        Input(), // Medication Dose Input.
        Input(), // Medication Time Input.
        ListTile(
            // Toggles "leftBehind" field of the current medication.
        ),
        ElevatedButton(
            // Save Button
        ),
        ElevatedButton(
            // Cancel Button
        )
    )
)
```

## Constructor

```dart
EditMedication(List<Medication> medications, Medication medication) {
    this.medications = medications;
    this.medication = medication;
}
```

* `medications` is the global list of medications that the app keeps track of.
* `medication` is the current medication that the user wants to look at.
