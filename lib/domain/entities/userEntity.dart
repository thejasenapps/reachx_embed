class UserEntity {
  String name;
  String phoneNo;
  String email;
  String? fcmToken;
  String subscriptionStatus;

  UserEntity({
    required this.name,
    required this.phoneNo,
    required this.email,
    this.fcmToken,
    required this.subscriptionStatus
  });
}