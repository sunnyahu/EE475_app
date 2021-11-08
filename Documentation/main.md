# Main

The Home Page of the app.

There is a List of Medications called `medications` which tracks all the users medications and displays them.

## Structure

```dart
Scaffold(
    // "appBar" is the "Title" seen at the top of the page.
    appBar: // "PillPal" Just the name of the App.
    // "body" contains all the elements in this page as a list of Widgets.
    body: Column(
        // Header that says "Medications" at the top of the page.
        HeaderText('Medications'),
        // The "Expanded" List of Medications found in the "medications" list.
        Expanded(
            // List of Medication ListTiles here. When clicked goes to the MedicationData() page.
            ListTile(
                OnClick: MedicationData()
            ),
            ...
        ),
        // Blue "+" Button in the bottom right of the screen.
        FloatingActionButton(
            // When this button is clicked, we want to add a new medication. This is why we pass
            // null as the "medication" parameter. This tells the EditMedication page that we want
            // to add a new medication instead of edit an old one.
            // The "medications" list is passed in so that if a new medication is created and the user
            // saves it, this list will be modified and will update the UI when the user returns to this
            // page.
            OnClick: EditMedication(medications, null); 
        )
    )
)
```

## Notes

You'll notice that after every `Navigator.push(...)` call, there's this code:

```dart
.then((value) {
    // Reload Home Page once the user enters their medication.
    setState(() {});
});
```

`Navigator.push(...)` pushes a page onto the navigation stack. I.e when the user clicks the Blue "+" button in the bottom right corner, the `EditMedication()` page is pushed onto the navigation stack. Once the user is done adding this medication, they pop this page back off the Navigation stack and go back to this page. If they added a medication, we want to update this page though! So what we do it we just force reload this page every time the user comes back to it (using the code snippet above) to ensure that any new medications show up in the UI.