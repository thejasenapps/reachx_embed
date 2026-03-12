import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/enums.dart';

class SubscriptionState {
  final Rx<SubscriptionStatus> _status = SubscriptionStatus.beginner.obs;

  SubscriptionStatus get current => _status.value;

  Rx<SubscriptionStatus> get listenable => _status;

  void update(SubscriptionStatus newStatus) {
    if(_status.value != newStatus) {
      _status.value = newStatus;
    }
  }
}