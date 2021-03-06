// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
      json['id'] as int,
    )
      ..seqNum = json['seqNum'] as int
      ..name = json['name'] as String?
      ..xDays = json['xDays'] as int
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..times = (json['times'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList()
      ..dosage = json['dosage'] as int
      ..nPills = json['nPills'] as int
      ..leftBehind = json['leftBehind'] as bool
      ..push = json['push'] as bool
      ..contacts = (json['contacts'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seqNum': instance.seqNum,
      'name': instance.name,
      'xDays': instance.xDays,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'times': instance.times.map((e) => e.toIso8601String()).toList(),
      'dosage': instance.dosage,
      'nPills': instance.nPills,
      'leftBehind': instance.leftBehind,
      'push': instance.push,
      'contacts': instance.contacts,
    };
