# Input

The Input Widget appears on the **Edit Medication** and **Add Medication** pages. It represents the text field AND the submit button.

## Constructor

```dart
Input(String text, Medication medication, String id) {
    this.text = text;
    this.medication = medication;
    this.id = id
}
```

* `text` is the text that appears inside the textfield.
* `medication` is the current medication that the user wants to look at or edit.
* `id` is essentially a flag that determines which field of the `medication` object gets set. See the `Medication` class `set` function to see why the `id` parameter is necessary.