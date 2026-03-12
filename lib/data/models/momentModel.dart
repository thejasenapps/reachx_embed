
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/momentEntity.dart';

class MomentModel extends MomentEntity{
  MomentModel({
    required super.selectedImage,
    required super.description,
    required super.date,
    required super.momentId,
    super.imageId,
    required super.timestamp
  });


  factory MomentModel.fromJson(Map<String, dynamic> json) => MomentModel(
      selectedImage: json["selectedImage"],
      description: json["description"] ?? '',
      date: json["date"].toDate(),
      imageId: json["imageId"] ?? '',
      momentId: json["momentId"] ?? '',
      timestamp: ((json["timestamp"] as Timestamp?) ??
          Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1)),
          ))
          .toDate(),
  );


  Map<String, dynamic> toJson() => {
    "selectedImage": selectedImage,
    "description": description,
    "date": date,
    "imageId": imageId ?? '',
    "momentId": momentId ,
    "timestamp": DateTime.now()
  };
}



class MomentsModel extends MomentsEntity{
  MomentsModel({required super.moments});
}