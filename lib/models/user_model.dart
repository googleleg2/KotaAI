class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final int loyaltyPoints;
  final bool notificationsEnabled;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.loyaltyPoints = 0,
    this.notificationsEnabled = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      loyaltyPoints: map['loyaltyPoints'] ?? 0,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'loyaltyPoints': loyaltyPoints,
      'notificationsEnabled': notificationsEnabled,
    };
  }
}