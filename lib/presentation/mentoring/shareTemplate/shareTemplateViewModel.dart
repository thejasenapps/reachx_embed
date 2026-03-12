import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'dart:ui' as ui;
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:share_plus/share_plus.dart';

class ShareTemplateViewModel {
  final GlobalKey globalKey = GlobalKey();

  Future<void> captureAndShare(TopicEntity topicEntity, BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final webUrl =
          "$appUrl?expertId=${topicEntity.expertId}&passion=${topicEntity.topicId}";

      XFile imageFile = XFile.fromData(
        pngBytes,
        name: 'shared_template.png',
        mimeType: 'image/png',
      );

      final box = context.findRenderObject() as RenderBox?;

      final params = ShareParams(
        text:
            "Book your slot to attend this session by ${topicEntity.expertName}: $webUrl",
        files: [imageFile],
        mailToFallbackEnabled: false,
        downloadFallbackEnabled: true,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      final result = await SharePlus.instance.share(params);
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  // Returns a formatted status list (e.g., ["1:1", "ONLINE"]) based on session type and delivery mode.
  List<String> sessionStatus(SessionEntity sessionEntity) {
    if (sessionEntity.sessionType == "1:1") {
      if (sessionEntity.session.toLowerCase() == "online") {
        return ["1:1", "ONLINE"];
      } else {
        return ["1:1", "OFFLINE"];
      }
    } else {
      if (sessionEntity.session.toLowerCase() == "online") {
        return ["LIVE", "WEBINAR"];
      } else if (sessionEntity.session.toLowerCase() == "onsite") {
        return ["LIVE", "SEMINAR"];
      } else {
        return [];
      }
    }
  }
}
