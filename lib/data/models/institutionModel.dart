import 'package:reachx_embed/domain/entities/institutionEntity.dart';

class InstitutionModel extends InstitutionEntity {
  InstitutionModel({
    required super.id,
    required super.name,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }


  factory InstitutionModel.fromEntity(InstitutionEntity entity) {
    return InstitutionModel(
      id: entity.id,
      name: entity.name,
    );
  }

  InstitutionEntity toEntity() {
    return InstitutionEntity(
      id: id,
      name: name,
    );
  }

  factory InstitutionModel.empty() {
    return InstitutionModel(
      id: '',
      name: '',
    );
  }
}