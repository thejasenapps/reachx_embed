import 'package:reachx_embed/domain/entities/userEntity.dart';

/// Represents the model for user sign-up, extending from SignUpEntity
class UserModel extends UserEntity {
  final String lastLogin;
  final String status = "1";  // Status field, defaults to "1"

  UserModel({
    required super.name,
    required super.phoneNo,
    required super.email,
    required super.subscriptionStatus,
    super.fcmToken,
    var uniqueId,
    String? lastLogin,
  }) : lastLogin = lastLogin ?? DateTime.now().toIso8601String();  // Initialize the base class with name and phoneNo

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      lastLogin: json["lastLogin"],
      fcmToken: json["fcmToken"],
      name: json["name"] ?? '',
      phoneNo: json["phone"] ?? '',
      email: json["email"] ?? '',
      subscriptionStatus: json["subscriptionStatus"] ?? 'beginner',
      uniqueId: json["uniqueId"] ?? ''
  );

  /// Converts the SignUpModel instance into a JSON object for API interaction
  /// Returns a Map with the user's details, including uniqueId and status
  Map<String, dynamic> toJson() => {
    'lastLogin': lastLogin,
    'fcmToken': fcmToken,
    'name': name,
    'email': email,
    'phone': phoneNo,
    'subscriptionStatus': subscriptionStatus
  };
}
