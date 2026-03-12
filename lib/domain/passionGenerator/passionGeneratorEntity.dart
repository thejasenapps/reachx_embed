class PassionEntity {
  int id;
  String title;
  String description;
  String imageUrl;

  PassionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl
  });
}



class PassionsEntity {
  List<PassionEntity> passionsEntity;

  PassionsEntity({
    required this.passionsEntity
  });
}


class AnswerSheetEntity {
  String id;
  String? userId;
  String? passionId;
  List<String> answers;
  DateTime timestamp;

  AnswerSheetEntity({
    required this.id,
    this.userId,
    this.passionId,
    required this.timestamp,
    required this.answers
  });
}