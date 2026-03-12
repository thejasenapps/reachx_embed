import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/subscription/subscriptionStateManager.dart';

class SubscriptionController extends GetxController {

  SubscriptionController() {
    onInit();
  }

  final SubscriptionState _state = SubscriptionState();

  SubscriptionState get state => _state;

  StreamSubscription? _subscriptionListener;

  @override
  void onInit() {
    super.onInit();
    _listenToFirestore();
  }


  void _listenToFirestore() {
    _subscriptionListener = FirebaseFirestore.instance.collection('subscriptions').doc("USER_ID").snapshots().listen((doc) {
      if(!doc.exists) {
        _state.update(SubscriptionStatus.beginner);
        return;
      }


      final statusString = doc.data()?['status'];

      _state.update(_mapStatus(statusString));
    });
  }



  SubscriptionStatus _mapStatus(String? value) {
    switch (value) {
      case 'beginner': return SubscriptionStatus.beginner;
      case 'interim': return SubscriptionStatus.interim;
      case 'professional': return SubscriptionStatus.professional;
      default: return SubscriptionStatus.beginner;
    }
  }


  @override
  void onClose() {
    _subscriptionListener?.cancel();
    super.onClose();
  }
}