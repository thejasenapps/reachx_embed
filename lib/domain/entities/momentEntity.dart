

class MomentEntity {
  dynamic selectedImage;
  String description;
  DateTime date;
  String? imageId;
  String momentId;
  DateTime timestamp;

  MomentEntity({
    required this.selectedImage,
    required this.description,
    required this.date,
    this.imageId,
    required this.momentId,
    required this.timestamp
  });
}

class MomentsEntity {
  List<MomentEntity> moments;

  MomentsEntity({required this.moments});
}