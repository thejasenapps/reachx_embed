import 'dart:io';
import 'package:flutter/foundation.dart';

double findPlatform() {
  if(kIsWeb) {
    return 100;
  } else if(Platform.isIOS) {
    return 130;
  } else {
    return 100;
  }
}