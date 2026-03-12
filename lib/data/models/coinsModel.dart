import 'package:reachx_embed/domain/entities/coinsEntity.dart';

class CoinsModel extends CoinsEntity {

  CoinsModel({
    required super.currentBalance,
    super.totalBalance,
    super.userId
  });


  factory CoinsModel.fromJson(Map<String, dynamic> json) => CoinsModel(
      currentBalance: json["currentBalance"],
      totalBalance: json["totalBalance"] ?? 0,
      userId: json["userId"] ?? ''
  );


  Map<String, dynamic> toJson () => {
    "currentBalance": currentBalance,
    if(totalBalance != null) "totalBalance": totalBalance,
    if(userId != null) "userId": userId
  };
}