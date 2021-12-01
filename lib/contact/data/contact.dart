// Contact Object
// Stores Contact information.

import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  late String? name;
  late String? phoneNumber;

  Contact() {
    name = null;
    phoneNumber = null;
  }

  @override
  bool operator ==(Object other) => other is Contact && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get id => "$name$phoneNumber";

  bool get isValid => name != null && phoneNumber != null;

  String get missing {
    List<String> missing = [];
    if (name == null) {
      missing.add('Name');
    }
    if (phoneNumber == null) {
      missing.add('Phone Number');
    }
    return missing.join(', ');
  }

  Contact copy() {
    return Contact()
      ..name = name
      ..phoneNumber = phoneNumber;
  }

  void copyFrom(Contact contact) {
    name = contact.name;
    phoneNumber = contact.phoneNumber;
  }

  dynamic get(String key) {
    switch (key) {
      case 'name':
        return name;
      case 'phoneNumber':
        return phoneNumber;
    }
  }

  void set(String key, dynamic value) {
    switch (key) {
      case 'name':
        name = value;
        break;
      case 'phoneNumber':
        phoneNumber = value;
        break;
    }
  }

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
