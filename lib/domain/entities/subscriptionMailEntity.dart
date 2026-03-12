class SubscriptionMailEntity {
  String event;
  String level;
  String section;
  String id;
  String currentLevel;

  SubscriptionMailEntity({
    required this.section,
    required this.level,
    required this.id,
    required this.event,
    required this.currentLevel
  });
}
