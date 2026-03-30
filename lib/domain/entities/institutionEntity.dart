class InstitutionEntity {
  String id;
  String name;
  String logo;
  String subscriptionId;
  bool subscriptionStatus;

  InstitutionEntity({
    required this.id,
    required this.name,
    required this.logo,
    required this.subscriptionStatus,
    required this.subscriptionId
  });
}
