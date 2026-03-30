import 'package:reachx_embed/domain/entities/institutionEntity.dart';

class InstitutionModel extends InstitutionEntity {
  InstitutionModel({
    required super.id,
    required super.name,
    required super.logo,
    required super.subscriptionId,
    required super.subscriptionStatus
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json["logo"] ?? '',
      subscriptionStatus: json['subscriptionStatus'] ?? false,
      subscriptionId: json["subscriptionId"] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionId': subscriptionId
    };
  }


  factory InstitutionModel.fromEntity(InstitutionEntity entity) {
    return InstitutionModel(
      id: entity.id,
      name: entity.name,
      logo: entity.logo,
      subscriptionId: entity.subscriptionId,
      subscriptionStatus: entity.subscriptionStatus
    );
  }

  InstitutionEntity toEntity() {
    return InstitutionEntity(
      id: id,
      name: name,
      logo: logo,
      subscriptionId: subscriptionId,
      subscriptionStatus: subscriptionStatus
    );
  }

  factory InstitutionModel.empty() {
    return InstitutionModel(
      id: '',
      name: '',
      logo: '',
      subscriptionStatus: false,
      subscriptionId: ''
    );
  }
}