import './data.dart';

class Medication {
  String name;
  int dose;
  bool leftBehind;
  List<String> dosageTimes;
  List<Data> history;

  bool isCancelled = false;

  Medication({
    required this.name,
    required this.dose,
    required this.leftBehind,
    required this.dosageTimes,
    required this.history,
  });

  void addHistory(Data data) {
    history.add(data);
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
        dosageTimes.add(value);
        break;
    }
  }
}
