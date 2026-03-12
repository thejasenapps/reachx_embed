
class FeedEntity {
  String? id;
  final FeedDataEntity postData;
  final String postType;
  final String badgeId;
  final String postId;
  String? likesCount;
  final String creatorId;
  DateTime? createdAt;
  int? liked;

  FeedEntity({
    this.id,
    required this.postData,
    required this.badgeId,
    required this.postType,
    required this.postId,
    this.likesCount,
    required this.creatorId,
    this.createdAt,
    this.liked,
  });
}

class FeedDataEntity {
  String expertImageUrl;
  String expertName;
  String title;
  String description;
  String mediaUrl;

  FeedDataEntity({
    required this.mediaUrl,
    required this.title,
    required this.description,
    required this.expertImageUrl,
    required this.expertName,
  });
}


class FeedEntities {
  final List<FeedEntity> feedEntities;

  FeedEntities({
    required this.feedEntities
  });
}