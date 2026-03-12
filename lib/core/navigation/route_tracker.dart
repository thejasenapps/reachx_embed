import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class NavigationRouteTracker extends GetxController with RouteAware {
  static NavigationRouteTracker get to => Get.find();

  final currentRoute = '/HomeScreen'.obs;

  @override
  void didPush() {
    currentRoute.value = ModalRoute.of(Get.context!)?.settings.name ?? '/HomeScreen';
  }


  @override
  void didPopNext() {
    currentRoute.value = ModalRoute.of(Get.context!)?.settings.name ?? '/HomeScreen';
  }
}