/// Firestore collection: "users"
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.address = '',
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
