/// PillPal
///
/// This file stores the "Medication" class which stores all information
/// related to the medication entered by the user.

import 'package:json_annotation/json_annotation.dart';

import '../../contact/data/contact.dart';

part 'medication.g.dart';

@JsonSerializable()
class Medication {
  late int id;
  late int seqNum;
  late String? name; // Name of the medication
  late int xDays; // Every X Number of days to take the medication
  late DateTime? startDate; // Start date of the medication
  late DateTime? endDate; // End date of the medication
  late List<DateTime> times; // Times of day to take the medication
  late int nPills;
  late int dosage; // Dosage of the medication
  late List<DateTime> dosageHistory; // History of the dosage of the medication
  late bool leftBehind; // Notify the user if the medication is left behind
  late bool push; // Send push notifications related to the medication
  late List<Contact> contacts; // Contacts to notify about the medication

  Medication(this.id) {
    seqNum = 0;
    name = null;
    xDays = 1;
    startDate = null;
    endDate = null;
    times = [];
    nPills = 0;
    dosage = 0;
    dosageHistory = [];
    leftBehind = false;
    push = false;
    contacts = [];
  }

  @override
  bool operator ==(Object other) => other is Medication && id == other.id;

  @override
  int get hashCode => id.hashCode;

  bool get isValid => name != null && startDate != null && times.isNotEmpty;

  String get missing {
    List<String> missing = [];
    if (name == null) {
      missing.add('Name');
    }
    if (startDate == null) {
      missing.add('Start Date');
    }
    if (times.isEmpty) {
      missing.add('Times');
    }
    return missing.join(', ');
  }

  dynamic get(String key) {
    switch (key) {
      case 'id':
        return id;
      case 'seqNum':
        return seqNum;
      case 'name':
        return name;
      case 'xDays':
        return xDays;
      case 'startDate':
        return startDate;
      case 'endDate':
        return endDate;
      case 'times':
        return times;
      case 'dosage':
        return dosage;
      case 'dosageHistory':
        return dosageHistory;
      case 'leftBehind':
        return leftBehind;
      case 'push':
        return push;
      case 'contacts':
        return contacts;
      default:
        return null;
    }
  }

  void set(String key, dynamic value) {
    switch (key) {
      case 'id':
        id = value;
        break;
      case 'seqNum':
        seqNum = value;
        break;
      case 'name':
        name = value;
        break;
      case 'xDays':
        xDays = value;
        break;
      case 'startDate':
        startDate = value;
        break;
      case 'endDate':
        endDate = value;
        break;
      case 'times':
        times = value;
        break;
      case 'dosage':
        dosage = value;
        break;
      case 'dosageHistory':
        dosageHistory = value;
        break;
      case 'leftBehind':
        leftBehind = value;
        break;
      case 'push':
        push = value;
        break;
      case 'contacts':
        contacts = value;
        break;
    }
  }

  Medication copy() {
    Medication result = Medication(id);
    result.seqNum = seqNum;
    result.name = name;
    result.xDays = xDays;
    result.startDate =
        startDate == null ? null : DateTime.parse(startDate!.toIso8601String());
    result.endDate =
        endDate == null ? null : DateTime.parse(endDate!.toIso8601String());

    result.times.addAll(times.map((e) => DateTime.parse(e.toIso8601String())));
    result.dosage = dosage;
    result.dosageHistory
        .addAll(dosageHistory.map((e) => DateTime.parse(e.toIso8601String())));
    result.leftBehind = leftBehind;
    result.push = push;
    result.contacts.addAll(contacts.map((e) => e.copy()));
    return result;
  }

  void copyFrom(Medication other) {
    Medication medication = other.copy();
    id = medication.id;
    seqNum = medication.seqNum;
    name = medication.name;
    xDays = medication.xDays;
    startDate = medication.startDate;
    endDate = medication.endDate;
    times = medication.times;
    dosage = medication.dosage;
    dosageHistory = medication.dosageHistory;
    leftBehind = medication.leftBehind;
    push = medication.push;
    contacts = medication.contacts;
  }

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}
