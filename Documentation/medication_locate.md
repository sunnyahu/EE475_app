# LocateMedication

The `LocateMedication` class is in the `medication_locate.dart` file.

Scans for bluetooth devices and displays them.

## Structure

```dart
Scaffold(
    // "appBar" is the "Title" seen at the top of the page.
    appBar: "Locate Medication",
    // "body" contains all the elements in this page as a list of Widgets.
    body: Column(
        ListTile(
            text: "Start Looking",
            // Look inside the "OnClick" function to change bluetooth logic.
            OnClick: // Scan for bluetooth devices and add them to the internal "devices" list.
        ),
        Expanded(
            ListTile(
                text: "Device MAC Address - Device RSSI"
            ),
            ...
        )
    )
)
```

## Constructor

Nothing is passed into the constructor yet. Most likely though, we'll have to include a `Medication` object so that we can use it's data to filter the bluetooth devices.