
class ExpertEntity {
  String uniqueId;
  String name;
  String location;
  int experience;
  int minutes;
  List<dynamic>? topics;
  String intro;
  double? rating;
  String? review;
  int? count;
  String? status;
  List<String> languages;
  String imageFile;
  String? imageId;
  bool? isExpert;
  List<String> achievements;
  String? badgeId;
  DateTime? timestamp;
  String? institutionId;

  ExpertEntity({
    required this.uniqueId,
    required this.name,
    required this.minutes,
    required this.topics,
    required this.intro,
    required this.location,
    required this.experience,
    this.rating,
    this.review,
    this.count,
    this.status,
    required this.languages,
    required this.imageFile,
    this.imageId,
    this.isExpert,
    required this.achievements,
    this.badgeId,
    this.timestamp,
    this.institutionId
  });
}


class ExpertsEntity {
  List<ExpertEntity> experts;

  ExpertsEntity({required this.experts});
}