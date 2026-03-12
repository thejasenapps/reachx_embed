import 'package:hive/hive.dart';

part 'userModel.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String keywordId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String passionName;

  @HiveField(4)
  final String passionDescription;

  @HiveField(5)
  String? answerId;

  UserModel({
    required this.id,
    required this.keywordId,
    required this.name,
    required this.passionName,
    required this.passionDescription,
    this.answerId
  });
}