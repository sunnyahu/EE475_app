# Medication History

The `MedicationHistory` class is in the `medication_history.dart` file.

## Structure

```dart
Scaffold(
    // "appBar" is the "Title" seen at the top of the page.
    appBar: // Medication Name if Medication is being Edited, otherwise just "Medication" 
    // "body" contains all the elements in this page as a list of Widgets.
    body: Column(
        // List of Times this medication was taken by the user.
        Expanded(
            ListTile(
                text: "Month/Day/Year" // Date medication was taken
                subtitle: "Time" // Time medication was taken
            )
        ),
    )
)
```

## Constructor

```dart
EditMedication(Medication medication) {
    this.medication = medication;
}
```

* `medication` is the current medication that the user wants to look at the history of.
