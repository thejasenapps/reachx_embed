import 'dart:io';

class ExpertListEntity {
  String uniqueId;
  String name;
  String intro;
  String? location;
  File audio;
  List<int> topics;

  ExpertListEntity({required this.name, required this.topics, required this.intro, this.location, required this.uniqueId, required this.audio});
}


class ExpertsListEntity {
  final List<ExpertListEntity> expertListEntity;

  ExpertsListEntity({required this.expertListEntity});
}