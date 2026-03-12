class TimeDaysEntity {
  final List<String> days;
  final String startTime;
  final String endTime;

  TimeDaysEntity({required this.days, required this.startTime, required this.endTime});
}



class ScheduleEntity {
  final int? id;
  final String name;
  final String timeZone;
  final List<TimeDaysEntity> availability;
  final bool isDefault;
  final List<TimeDaysEntity>? overrides;

  ScheduleEntity({required this.name, required this.timeZone, required this.availability, required this.isDefault, this.overrides, this.id});
}