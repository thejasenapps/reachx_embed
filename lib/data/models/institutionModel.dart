import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/institutionEntity.dart';

class InstitutionModel extends InstitutionEntity {
  InstitutionModel({
    required super.id,
    required super.name,
    required super.logo,
    required super.subscriptionId,
    required super.subscriptionStatus,
    required super.domainUrl,
    super.startDate,
    super.trialLimit
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json["logo"] ?? '',
      subscriptionStatus: json['subscriptionStatus'] ?? false,
      subscriptionId: json["subscriptionId"] ?? '',
      domainUrl: json["domainUrl"] ?? '',
      trialLimit: json["trialLimit"] ?? 7,
      startDate: json['startDate'] != null
          ? (json['startDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionId': subscriptionId,
      'startDate': startDate,
      'domainUrl': domainUrl,
      'trialLimit': trialLimit ?? 7
    };
  }


  factory InstitutionModel.fromEntity(InstitutionEntity entity) {
    return InstitutionModel(
      id: entity.id,
      name: entity.name,
      logo: entity.logo,
      subscriptionId: entity.subscriptionId,
      subscriptionStatus: entity.subscriptionStatus,
      startDate: entity.startDate,
      domainUrl: entity.domainUrl,
      trialLimit: entity.trialLimit
    );
  }

  InstitutionEntity toEntity() {
    return InstitutionEntity(
      id: id,
      name: name,
      logo: logo,
      subscriptionId: subscriptionId,
      subscriptionStatus: subscriptionStatus,
      domainUrl: domainUrl,
      startDate: startDate,
      trialLimit: trialLimit
    );
  }

  factory InstitutionModel.empty() {
    return InstitutionModel(
      id: '',
      name: '',
      logo: '',
      subscriptionStatus: false,
      subscriptionId: '',
      domainUrl: '',
      trialLimit: 7
    );
  }
}