import 'package:reachx_embed/domain/entities/roadMapEntity.dart';

class RoadMapModel extends RoadMapEntity {
  RoadMapModel({
    required super.description,
    required super.durationSeconds,
    required super.serialNumber,
    required super.title,
    required super.userId,
    required super.videoId
  });


  factory RoadMapModel.fromJson(Map<String, dynamic> json ) => RoadMapModel(
      description: json['description'] ?? '',
      durationSeconds: json['duration_seconds'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      title: json['title'],
      userId: json['user_id'] ?? '',
      videoId: json['video_id'] ?? ''
  );


  Map<String, dynamic> toJson() => {
    "description": description,
    "duration_seconds": durationSeconds,
    "serial_number": serialNumber,
    "title": title,
    "user_id": userId,
    "video_id": videoId
  };
}



class RoadMapsModel extends RoadMapsEntity {

  RoadMapsModel({
    required super.roadMaps
  });


  factory RoadMapsModel.fromJson(List<dynamic> json) => RoadMapsModel(
      roadMaps: List<RoadMapModel>.from(json.map((x) => RoadMapModel.fromJson(x as Map<String, dynamic>)))
  );

}