import 'package:reachx_embed/domain/entities/institutionEntity.dart';

class InstitutionModel extends InstitutionEntity {
  InstitutionModel({
    required super.id,
    required super.name,
    required super.logo
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json["logo"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }


  factory InstitutionModel.fromEntity(InstitutionEntity entity) {
    return InstitutionModel(
      id: entity.id,
      name: entity.name,
      logo: entity.logo
    );
  }

  InstitutionEntity toEntity() {
    return InstitutionEntity(
      id: id,
      name: name,
      logo: logo
    );
  }

  factory InstitutionModel.empty() {
    return InstitutionModel(
      id: '',
      name: '',
      logo: ''
    );
  }
}