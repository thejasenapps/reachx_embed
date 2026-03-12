import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/requestEntity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    required super.requestId,
    required super.expertId,
    required super.timestamp,
    required super.userId
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
      requestId: json["requestId"],
      expertId: json["expertId"] ?? '',
      timestamp: (json["timestamp"] as Timestamp).toDate(),
      userId: json["userId"] ?? ''
  );


  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "expertId": expertId,
    "userId": userId,
    "timestamp": timestamp
  };
}


class MultipleRequestsModel extends MultipleRequestsEntity {
  MultipleRequestsModel({
    required super.requests
  });

  factory MultipleRequestsModel.fromJson(dynamic json) => MultipleRequestsModel(
      requests: List<RequestModel>.from(json.map((x) => RequestModel.fromJson(x.data() as Map<String, dynamic>)))
  );
}