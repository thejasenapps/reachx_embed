import 'package:reachx_embed/data/models/badgeModel.dart';

class BadgeEntity {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl;

  const BadgeEntity({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl
  });
}


class BadgeEntityList {
  final List<BadgeModel> badges;

  BadgeEntityList({
    required this.badges
  });
}