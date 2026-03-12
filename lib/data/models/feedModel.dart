import 'package:reachx_embed/domain/entities/feedEntity.dart';

class FeedModel extends FeedEntity {
  FeedModel({
    super.id,
    required super.postData,
    required super.postType,
    required super.badgeId,
    required super.postId,
    super.likesCount,
    required super.creatorId,
    super.createdAt,
    super.liked,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'] ?? '',
      postData: FeedDataModel.fromJson(json['post_data'] ?? {}),
      postType: json['post_type'] ?? '',
      badgeId: json['badge_id'] ?? '',
      postId: json['post_id'] ?? '',
      likesCount: json['likes_count']?.toString() ?? '0',
      creatorId: json['creator_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      liked: json['liked'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'p_post_data': (postData as FeedDataModel).toJson(),
      'p_post_type': postType,
      'p_badge_id': badgeId,
      'p_post_id': postId,
      'p_creator_id': creatorId,
    };
  }

  FeedEntity toEntity() {
    return FeedEntity(
      id: id,
      postData: postData,
      postType: postType,
      badgeId: badgeId,
      postId: postId,
      likesCount: likesCount,
      creatorId: creatorId,
      createdAt: createdAt,
      liked: liked,
    );
  }
}


class FeedDataModel extends FeedDataEntity {
  FeedDataModel({
    required super.title,
    required super.mediaUrl,
    required super.description,
    required super.expertImageUrl,
    required super.expertName,
  });

  factory FeedDataModel.fromJson(Map<String, dynamic> json) {
    return FeedDataModel(
      title: json['title'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      description: json["description"] ?? '',
      expertImageUrl: json['expert_image_url'] ?? '',
      expertName: json["expert_name"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'media_url': mediaUrl,
      'description': description,
      'expert_image_url': expertImageUrl,
      'expert_name': expertName,
    };
  }

  FeedDataEntity toEntity() {
    return FeedDataEntity(
      title: title,
      mediaUrl: mediaUrl,
      description: description,
      expertName: expertName,
      expertImageUrl: expertImageUrl,
    );
  }
}

class FeedModels extends FeedEntities {
  FeedModels({
    required super.feedEntities,
  });

  factory FeedModels.fromJson(List<dynamic> json) {
    return FeedModels(
      feedEntities: json
          .map((e) => FeedModel.fromJson(e).toEntity())
          .toList(),
    );
  }

  factory FeedModels.empty() {
    return FeedModels(
        feedEntities: []
    );
  }

  FeedEntities toEntity() {
    return FeedEntities(
      feedEntities: feedEntities,
    );
  }
}