class InstitutionEntity {
  String id;
  String name;
  String logo;
  bool subscriptionStatus;
  DateTime? subscriptionStartDate;
  String domainUrl;
  int? trialLimit;
  DateTime? subscriptionEndDate;
  int? subscriptionAmount;
  List<String>? subscriptionHistory;
  String? origin;
  DateTime? registeredAt;

  InstitutionEntity({
    required this.id,
    required this.name,
    required this.logo,
    required this.subscriptionStatus,
    required this.domainUrl,
    this.subscriptionStartDate,
    this.subscriptionHistory,
    this.subscriptionEndDate,
    this.subscriptionAmount,
    this.trialLimit,
    this.origin,
    this.registeredAt
  });
}
