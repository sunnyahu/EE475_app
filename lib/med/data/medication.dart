/// PillPal
///
/// This file stores the "Medication" class which stores all information
/// related to the medication entered by the user.
/// The accompanying "Data" class is used to store the usage history by the
/// user by storing the dates the medication was taken.

class Medication {
  late int id;
  late Map<String, dynamic> prescription;
  late Map<String, dynamic> history;
  late Map<String, dynamic> notificationSettings;

  Medication(this.id) {
    prescription = {'name': null, 'times': <DateTime>[], 'dosage': null};
    history = {
      'dosage': <DateTime>[],
      'notifications': <Map<DateTime, String>>[]
    };
    notificationSettings = {
      'leave': false,
      'push': false,
      'social': {},
    };
  }

  Medication.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    prescription = map['prescription'];
    history = map['history'];
    notificationSettings = map['notification_settings'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescription': prescription,
      'history': history,
      'notification_settings': notificationSettings
    };
  }

  void set(String field, dynamic value) {
    switch (field) {
      case 'id':
        id = value;
        break;
      case 'prescription':
        prescription = value;
        break;
      case 'history':
        history = value;
        break;
      case 'notificationSettings':
        notificationSettings = value;
        break;
    }
  }
}
