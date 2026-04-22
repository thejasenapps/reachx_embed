import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/institutionEntity.dart';

class InstitutionModel extends InstitutionEntity {
  InstitutionModel({
    required super.id,
    required super.name,
    required super.logo,
    required super.subscriptionStatus,
    required super.domainUrl,
    super.subscriptionStartDate,
    super.subscriptionEndDate,
    super.subscriptionAmount,
    super.subscriptionHistory,
    super.trialLimit,
    super.origin,
    super.registeredAt,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      subscriptionStatus: json['subscriptionStatus'] ?? false,
      domainUrl: json['domainUrl'] ?? '',
      trialLimit: json['trialLimit'] ?? 7,
      subscriptionStartDate: json['subscriptionStartDate'] != null
          ? (json['subscriptionStartDate'] as Timestamp).toDate()
          : null,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? (json['subscriptionEndDate'] as Timestamp).toDate()
          : null,
      subscriptionAmount: json['subscriptionAmount'],
      subscriptionHistory: (json['subscriptionHistory'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      origin: json['origin'],
      registeredAt: json['registeredAt'] != null
          ? (json['registeredAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'subscriptionStatus': subscriptionStatus,
      'domainUrl': domainUrl,
      'trialLimit': trialLimit ?? 7,
      if (subscriptionStartDate != null) 'subscriptionStartDate': subscriptionStartDate,
      if (subscriptionEndDate != null) 'subscriptionEndDate': subscriptionEndDate,
      if (subscriptionAmount != null) 'subscriptionAmount': subscriptionAmount,
      if (subscriptionHistory != null) 'subscriptionHistory': subscriptionHistory,
      if (origin != null) 'origin': origin,
      if (registeredAt != null) 'registeredAt': registeredAt,
    };
  }

  factory InstitutionModel.fromEntity(InstitutionEntity entity) {
    return InstitutionModel(
      id: entity.id,
      name: entity.name,
      logo: entity.logo,
      subscriptionStatus: entity.subscriptionStatus,
      domainUrl: entity.domainUrl,
      trialLimit: entity.trialLimit,
      subscriptionStartDate: entity.subscriptionStartDate,
      subscriptionEndDate: entity.subscriptionEndDate,
      subscriptionAmount: entity.subscriptionAmount,
      subscriptionHistory: entity.subscriptionHistory,
      origin: entity.origin,
      registeredAt: entity.registeredAt,
    );
  }

  InstitutionEntity toEntity() {
    return InstitutionEntity(
      id: id,
      name: name,
      logo: logo,
      subscriptionStatus: subscriptionStatus,
      domainUrl: domainUrl,
      trialLimit: trialLimit,
      subscriptionStartDate: subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate,
      subscriptionAmount: subscriptionAmount,
      subscriptionHistory: subscriptionHistory,
      origin: origin,
      registeredAt: registeredAt,
    );
  }

  factory InstitutionModel.empty() {
    return InstitutionModel(
      id: '',
      name: '',
      logo: '',
      subscriptionStatus: false,
      domainUrl: '',
      trialLimit: 7,
    );
  }
}
