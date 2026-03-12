import 'package:reachx_embed/domain/entities/susbcriptionEntity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    required super.beginner,
    required super.interim,
    required super.professional,
  });

  factory SubscriptionModel.fromJson(List<dynamic> json) => SubscriptionModel(
      beginner: SubscriptionTypeModel.fromJson(json[0] as Map<String, dynamic>),
      interim: SubscriptionTypeModel.fromJson(json[1] as Map<String, dynamic>),
      professional: SubscriptionTypeModel.fromJson(json[2] as Map<String, dynamic>)
  );
}

class SubscriptionTypeModel extends SubscriptionTypeEntity {
  SubscriptionTypeModel({
    super.journalCreate,
    super.journalShow,
    super.learningContentChange
  });

  factory SubscriptionTypeModel.fromJson(Map<String, dynamic> json) => SubscriptionTypeModel(
      journalCreate: json["journalCreate"] ?? false,
      journalShow: json["journalShow"] ?? false,
      learningContentChange: json["learningContentChange"] ?? false
  );
}

