import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Future<dynamic> resizeImage(dynamic file) async {
  try {
    Uint8List imageBytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if(image == null) {
        throw Exception("Invalid image file");
        }
      img.Image resizedImage = img.copyResize(
          image,
          width: 500,
          interpolation: img.Interpolation.cubic
      );

    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 100));
  } catch(e) {
    print(e);
  }
}