class InstitutionEntity {
  String id;
  String name;
  String logo;
  String subscriptionId;
  bool subscriptionStatus;
  DateTime? startDate;
  String domainUrl;
  int? trialLimit;

  InstitutionEntity({
    required this.id,
    required this.name,
    required this.logo,
    required this.subscriptionStatus,
    required this.subscriptionId,
    required this.domainUrl,
    this.startDate,
    this.trialLimit
  });
}
