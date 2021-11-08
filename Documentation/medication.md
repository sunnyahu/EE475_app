# Medication

`Medication` objects store all data relating to a Medication.

```dart
class Medication {
  String? name;
  int? dose;
  bool? leftBehind;
  List<String>? dosageTimes;
  List<Data>? history;

  Medication({this.name, this.dose, this.leftBehind}) {
    dosageTimes = [];
    history = [];
  }

  void addHistory(Data data) {
    history!.add(data);
  }

  void set(id, value) {
    switch (id) {
      case 'name':
        name = value;
        break;
      case 'dose':
        dose = value;
        break;
      case 'time':
        dosageTimes!.add(value);
        break;
    }
  }
}

class Data {
  int day, month, year;
  String time;

  Data({
    required this.day,
    required this.month,
    required this.year,
    required this.time,
  });
}
```