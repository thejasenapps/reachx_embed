import 'package:reachx_embed/domain/entities/ratingEntity.dart';

class RatingModel extends RatingEntity{
  RatingModel({
    required super.uniqueId,
    required super.rating,
    required super.review
  });



  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
      uniqueId: json["ratingId"] ?? '',
      rating: json["rating"] ?? 0,
      review: json["review"] ?? ''
  );


  Map<String, dynamic> toJson() => {
      "uniqueId": uniqueId,
      "rating": rating,
      "review": review
    };
}