class UserEntity {
  String name;
  String phoneNo;
  String email;
  String? fcmToken;
  String subscriptionStatus;
  String? institutionId;

  UserEntity({
    required this.name,
    required this.phoneNo,
    required this.email,
    this.fcmToken,
    required this.subscriptionStatus,
    this.institutionId
  });
}