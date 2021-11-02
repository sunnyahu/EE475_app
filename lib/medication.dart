/// PillPal
///
/// This file stores the "Medication" class which stores all information
/// related to the medication entered by the user.
/// The accompanying "Data" class is used to store the usage history by the
/// user by storing the dates the medication was taken.

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
