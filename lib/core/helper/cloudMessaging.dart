import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/navigation/navigationController.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedScheduleScreen.dart';


Future<void> initNotifications() async {
  try {
    final firebaseMessaging = FirebaseMessaging.instance;

    final settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true
    );

    debugPrint("notification permission: ${settings.authorizationStatus}");

    fcmToken = (await firebaseMessaging.getToken())!;

    print(fcmToken);

    firebaseMessaging.subscribeToTopic("all");

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Foreground notification: ${message.notification?.title}");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  } catch(e) {
    print(e);
  }
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  handleNotification(message);
}





void handleNotification(RemoteMessage message) {
  Get.toNamed(
    BookedScheduleScreen.route,
    id: NavIds.bookings
  );

  NavigationController.to.changePage(NavIds.bookings);
}