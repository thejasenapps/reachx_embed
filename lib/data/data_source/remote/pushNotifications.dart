import 'package:dio/dio.dart';

class PushNotifications {
  final Dio _dio = Dio();

  Future<bool> sendPushNotifications(List<String> fcmTokens, String title, String content, Map<String, dynamic> sendData) async {

    Map<String, dynamic> data = {
      "fcmToken": fcmTokens,
      "message": {
        "title": title,
        "content": content,
        "userData": sendData
      }
    };

    try {
      var response = await _dio.post(
        "https://node-test-rev.vercel.app/send-notification",
        data: data
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}