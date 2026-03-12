
class TopicEntity {
  String? expertId;
  String name;
  String topicId;
  String? expertName;
  String description;
  int topicRate;
  String sessionId;
  String session;
  String sessionType;
  List<String>? expertise;
  double? rating;
  String? location;
  int?count;
  String? status;
  String? skillType;
  String? imageUrl;
  var audio;
  String? audioId;
  List<String>? languages;
  String? currencySymbol;
  List<String>? momentsIds;
  bool availability;
  String? keywordId;
  String? meetingUrl;
  String? badgeId;
  DateTime? timestamp;

  TopicEntity({
    this.expertId,
    required this.name,
    this.expertName,
    required this.description,
    required this.topicRate,
    required this.sessionId,
    required this.session,
    required this.sessionType,
    this.location,
    required this.topicId,
    this.expertise,
    this.rating,
    this.count,
    this.status,
    this.skillType,
    this.imageUrl,
    this.audio,
    this.languages,
    this.audioId,
    this.currencySymbol,
    this.momentsIds,
    required this.availability,
    this.keywordId,
    this.meetingUrl,
    this.badgeId,
    this.timestamp
  });
}


class TopicsEntity {
  List<TopicEntity> topics;

  TopicsEntity({required this.topics});
}