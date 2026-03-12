import 'package:reachx_embed/data/models/toolsModel.dart';

class ToolEntity {
  String? id;
  final String toolName;
  final String toolDescription;
  final String toolLink;
  dynamic imagePath;
  final String badgeId;
  String? badgeKeyword;
  String? badgeName;
  String? badgeThumbnail;
  final bool isPublic;
  String? source;
  bool isActive;
  String? userId;

  ToolEntity({
    this.id,
    required this.imagePath,
    required this.isActive,
    required this.badgeId,
    this.badgeKeyword,
    this.badgeName,
    this.badgeThumbnail,
    required this.isPublic,
    required this.toolDescription,
    required this.toolLink,
    required this.toolName,
    this.source,
    this.userId
  });
}


class ToolsEntity {
  List<ToolModel> tools;

  ToolsEntity({
    required this.tools
  });
}