class RoadMapEntity {
  String title;
  String videoId;
  String serialNumber;
  String description;
  String userId;
  String durationSeconds;

  RoadMapEntity({
    required this.description,
    required this.title,
    required this.serialNumber,
    required this.videoId,
    required this.userId,
    required this.durationSeconds
  });
}


class RoadMapsEntity {
  List<RoadMapEntity> roadMaps;

  RoadMapsEntity({required this.roadMaps});
}