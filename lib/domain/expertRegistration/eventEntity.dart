class EventEntity {
  int lengthInMinutes;
  List<int> lengthInMinutesOptions;
  String title;
  String slug;
  String description;
  int scheduleId;

  EventEntity({required this.title, required this.slug, required this.lengthInMinutes, required this.lengthInMinutesOptions, required this.description, required this.scheduleId});
}