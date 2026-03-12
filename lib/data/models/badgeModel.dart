import 'package:reachx_embed/domain/entities/badgeEntity.dart';

class BadgeModel extends BadgeEntity {
  const BadgeModel({
    required super.id,
    required super.name,
    required super.thumbnailUrl,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.imageUrl
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      imageUrl: json["image_url"] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail_url': thumbnailUrl,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl
    };
  }
}




class BadgeModelList extends BadgeEntityList {
  BadgeModelList({required super.badges});

  factory BadgeModelList.fromJson(List<dynamic> json) {
    return BadgeModelList(
      badges: List<BadgeModel>.from(
        json.map((x) => BadgeModel.fromJson(x as Map<String, dynamic>)),
      ),
    );
  }
}
