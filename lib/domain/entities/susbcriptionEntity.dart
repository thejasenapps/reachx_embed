class SubscriptionEntity {
  final SubscriptionTypeEntity beginner;
  final SubscriptionTypeEntity interim;
  final SubscriptionTypeEntity professional;

  SubscriptionEntity({
    required this.professional,
    required this.interim,
    required this.beginner
  });
}

class SubscriptionTypeEntity {
  bool? journalCreate;
  bool? journalShow;
  bool? learningContentChange;

  SubscriptionTypeEntity({
    this.journalCreate,
    this.journalShow,
    this.learningContentChange
  });
}
