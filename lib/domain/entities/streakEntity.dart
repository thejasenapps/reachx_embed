class StreakEntity {
  String userId;
  String passionId;
  int lastCount;
  DateTime lastUpdatedDate;
  bool answered;
  bool completed;

  StreakEntity({
    required this.userId,
    required this.lastCount,
    required this.lastUpdatedDate,
    required this.passionId,
    required this.answered,
    required this.completed
  });
}