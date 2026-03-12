import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappNotifications {

  final Dio _dio = Dio();

  final whatsappNumber = EnvConfig.whatsappNumber;
  final whatsappToken = EnvConfig.whatsappAccessToken;

  Future<bool> sendBookingAlertToPassionate(Map<String, dynamic> data) async {
    try {

      const String url = 'https://app.reachx.pro/api/send.php';

      final body = json.encode({
        "channel": "whatsapp",
        "number": data["expertNo"],
        "template": "meeting_confirmed_online",
        "parameters": [
          {"type": "text", "parameter_name": "topic", "text": data["topic"]},
          {"type": "text", "parameter_name": "time", "text": data["time"]},
          {"type": "text","parameter_name": "country_code", "text": "IST"},
          {"type": "text","parameter_name": "mode", "text": data["mode"]}
        ]
      });

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type' : 'application/json'
          },
          responseType: ResponseType.plain
        ),
        data: body
      );


      if(response .statusCode == 200) {
        debugPrint('Message sent successfully');

        return true;
      }

      debugPrint('Message sending failed');
      return  false;
    } catch(e) {
      debugPrint("Exception: $e");
      return false;
    }
  }

  Future<bool> sendInvitationToUsers(String phoneNumber, String senderName) async {
    try {
      final message = '''
          Hi there! 👋

          I’m growing my passion with ReachX. Join me and be part of a community where we share, support, and grow together.

          Click the link below to download the app and join now:
          https://reachx.pro/download-app.html

          See you inside!  
          – $senderName
          ''';

      final encodedMessage = Uri.encodeComponent(message);
      final url = Uri.parse("https://wa.me/$phoneNumber?text=$encodedMessage");

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      } else {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

}