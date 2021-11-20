// Contact Object
// Stores Contact information.

class Contact {
  late String name;
  late String phoneNumber;

  void fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
    };
  }
}
