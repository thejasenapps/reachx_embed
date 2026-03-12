
import 'package:reachx_embed/domain/entities/toolEntity.dart';

class ToolModel extends ToolEntity {
  ToolModel({
    super.id,
    required super.imagePath,
    required super.toolName,
    required super.isActive,
    required super.badgeId,
    super.badgeKeyword,
    super.badgeName,
    super.badgeThumbnail,
    required super.isPublic,
    required super.toolDescription,
    required super.toolLink,
    super.source,
    super.userId
  });

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      id: json['id'] ?? '',
      imagePath: json['image_path'] ?? '',
      isActive: json["is_active"] ?? false,
      toolName: json["tool_name"] ?? '',
      badgeId: json["badge_id"] ?? '',
      toolLink: json["tool_link"] ?? '',
      badgeKeyword: json["badge_keyword"] ?? '',
      badgeName: json["badge_name"] ?? '',
      badgeThumbnail: json["badge_thumbnail"] ?? '',
      isPublic: json["is_public"] ?? '',
      toolDescription: json["tool_description"] ?? '',
      source: json["source"] ?? 'custom'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'image_path': imagePath,
      'tool_name': toolName,
      'badge_id': badgeId,
      'tool_link': toolLink,
      'is_public': isPublic,
      'tool_description': toolDescription,
    };
  }
}


class ToolsModel extends ToolsEntity {
  ToolsModel({
    required super.tools
  });

  factory ToolsModel.fromJson(List<dynamic> json) => ToolsModel(
      tools: List<ToolModel>.from(json.map((x) => ToolModel.fromJson(x as Map<String, dynamic>)))
  );
}
