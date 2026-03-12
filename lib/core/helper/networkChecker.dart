import 'dart:io';

import 'package:flutter/foundation.dart';

Future<bool> fetchData({int seconds = 10}) async {
  if(kIsWeb) {
    return true;
  } else {
    try {
      final result = await InternetAddress.lookup('google.com')
        .timeout(Duration(seconds: seconds));

      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }

      return false;
    } on SocketException catch(_) {
      print('No internet connection. Please check your network settings');
      return false;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return false;
    }
  }
}