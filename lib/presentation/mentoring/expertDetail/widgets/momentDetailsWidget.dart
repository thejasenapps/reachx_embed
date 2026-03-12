import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/momentEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customPlaceHolderImage.dart';
import 'package:reachx_embed/presentation/commonWidgets/imageViewWidget.dart';
import 'package:get/get.dart';

class MomentDetailsWidget extends StatefulWidget {
  MomentEntity momentEntity;
  int index;
  bool lastElement;
  String topicId;
  String topicName;

  MomentDetailsWidget({
    super.key,
    required this.momentEntity,
    required this.index,
    required this.lastElement,
    required this.topicId,
    required this.topicName
  });

  @override
  State<MomentDetailsWidget> createState() => _MomentDetailsWidgetState();
}

class _MomentDetailsWidgetState extends State<MomentDetailsWidget> {
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  void viewInFullScreen() {
    showDialog(
        context: context,
        builder: (context) => ImageViewWidget(
            image: widget.momentEntity.selectedImage
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        crossAxisAlignment: widget.index % 2 == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: GestureDetector(
              onTap: () => viewInFullScreen(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                      angle: widget.index % 2 == 0 ? -0.15 : 0.15,
                      child: Image.asset(
                        'lib/assets/images/frame.webp',
                        width: 210,
                        height: 260,
                      ),
                  ),
                  Transform.rotate(
                    angle: widget.index % 2 == 0 ? -0.15 : 0.15,
                    child: SizedBox(
                      width: 160,
                      height: 230,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.none,
                        child: CachedNetworkImage(
                          imageUrl: widget.momentEntity.selectedImage.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CustomPlaceHolderImage(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: const Icon(
                                Iconsax.image
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.calendar,
                color: HexColor(lightBlue),
              ),
              Text(
                _dateAndTimeConvertors.formatDate(widget.momentEntity.date.toString()),
                style: const TextStyle(
                  color: Colors.grey
                ),
              )
            ],
          ),
          Text(
            widget.momentEntity.description,
            style: const TextStyle(
                color: Colors.grey
            ),
          ),
          if(widget.lastElement)
            const SizedBox(height: 50,)
        ],
      ),
    );
  }
}
