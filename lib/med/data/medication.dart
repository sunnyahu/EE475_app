/// PillPal
///
/// This file stores the "Medication" class which stores all information
/// related to the medication entered by the user.

class Medication {
  late int id;
  late Map<String, dynamic> prescription;
  late Map<String, dynamic> history;
  late Map<String, dynamic> notificationSettings;

  Medication(this.id) {
    prescription = {
      'name': null, // Medication Name
      'start_date': null, // Start Date
      'end_date': null, // End Date
      'times': <DateTime>[], // Times user should take the medication every day
      'dosage': null, // Number of pills/medication to take for each times.
    };
    history = {
      'dosage': <DateTime>[],
      'notifications': <Map<DateTime, String>>[],
    };
    notificationSettings = {
      'leftBehind': false, // Notification for leaving bottle behind
      'push': false, // Dis/enable push notifications
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
}
