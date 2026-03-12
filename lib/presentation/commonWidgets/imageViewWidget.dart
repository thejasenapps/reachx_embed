import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class ImageViewWidget extends StatelessWidget {
  final dynamic image; // File or URL

  const ImageViewWidget({
    super.key,
    required this.image,
  });

  Future<ui.Image> _getImageDimensions(dynamic image) async {
    if (image is File) {
      final bytes = await image.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return frame.image;
    } else if (image is String) {
      final networkImage = NetworkImage(image);
      final completer = Completer<ui.Image>();
      networkImage.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) {
          completer.complete(info.image);
        }),
      );
      return completer.future;
    } else {
      throw Exception("Unsupported image type");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _getImageDimensions(image),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                color: HexColor(loadingIndicatorColor),
              )
          );
        }

        final img = snapshot.data!;
        final aspectRatio = img.width / img.height;

        return AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Hero(
                    tag: image,
                    child: InteractiveViewer(
                      child: image is File
                          ? Image.file(image, fit: BoxFit.contain)
                          : Image.network(image, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.black,
                        size: 25
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
