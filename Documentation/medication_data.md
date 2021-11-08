# MedicationData

The `MedicationData` class is in the `medication_data.dart` file.

The `MedicationData` class is the page of the app that looks like this:

<img src="Documentation/Pages/MedicationData.png" alt="MedicationData page" width=50% />

## Structure

```dart
Scaffold(
    // "appBar" is the "Title" seen at the top of the page.
    appBar: // Medication Name
    // "body" contains all the elements in this page as a list of Widgets.
    body: Column(
        // Button for "Locate Bottle"
        ListTile(
            // Opens LocateMedication() page
        ),
        Divider(), // Visual Divider. For visual purposes only.
        // Button for "View History"
        ListTile(
            // Opens MedicationHistory(medication) page with current medication passed in
        ),
        Divider(),
        // Button for "View/Edit Information"
        ListTile(
            // Opens EditMedication(medications, medication) page with current medication passed
            // in as well as the global list of medications
        ),
        Divider(),
        // Button for "Delete Medication" 
        ListTile(
            // Opens a Dialog that asks the user to confirm if they want to delete the current medication.
            // If the user clicks "Yes" the current medication is removed from the medications list.
            // medications.remove(medication);
        )
    )
)
```

## Constructor

```dart
MedicationData(List<Medication> medications, Medication medication) {
    this.medications = medications;
    this.medication = medication;
}
```

`medications` is the global list of medications that the app keeps track of.
`medication` is the current medication that the user wants to look at.
