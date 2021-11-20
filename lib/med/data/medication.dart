/// PillPal
///
/// This file stores the "Medication" class which stores all information
/// related to the medication entered by the user.

import '../../contact/data/contact.dart';

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
      'left_behind': false, // Notification for leaving bottle behind
      'push': false, // Dis/enable push notifications
      'social': <Contact>[],
    };
  }

  Medication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescription = {
      'name': json['prescription']['name'],
      'start_date': DateTime.parse(json['prescription']['start_date']),
      'end_date': json['end_date'] == 'null'
          ? null
          : DateTime.parse(json['prescription']['end_date']),
      'times': json['prescription']['times']
          .map((time) => DateTime.parse(time))
          .toList(),
      'dosage': int.parse(json['prescription']['dosage']),
    };
    history = json['history'];
    notificationSettings = json['notification_settings'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescription': {
        'name': prescription['name'],
        'start_date': prescription['start_date'].toString(),
        'end_date': prescription['end_date'].toString(),
        'times': prescription['times'].map((time) => time.toString()).toList(),
        'dosage': prescription['dosage'].toString(),
      },
      'history': {
        'dosage': history['dosage'].map((time) => time.toString()).toList(),
        'notifications': history['notifications'],
      },
      'notification_settings': {
        'left_behind': notificationSettings['left_behind'].toString(),
        'push': notificationSettings['push'].toString(),
        'social': notificationSettings['social']
            .map((contact) => contact.toJson())
            .toList(),
      }
    };
  }
}
