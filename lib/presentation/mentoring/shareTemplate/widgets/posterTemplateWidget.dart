import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/shareTemplateViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/widgets/sessionFinderWidget.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/widgets/sessionStatusWidget.dart';

class PosterTemplateWidget extends StatelessWidget {

  final ShareTemplateViewModel shareTemplateViewModel;
  final TopicEntity topicEntity;
  final SessionEntity sessionEntity;

  PosterTemplateWidget({
    super.key,
    required this.shareTemplateViewModel,
    required this.topicEntity,
    required this.sessionEntity
  });

  double mainFontSize = 30;

  @override
  Widget build(BuildContext context) {

    if(topicEntity.name.length > 15) {
      mainFontSize = (25 - (topicEntity.name.length - 15)/2);
    } else {
      mainFontSize = 25;
    }

    return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: HexColor(containerBorderColor))
                  ),
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: RepaintBoundary(
                    key: shareTemplateViewModel.globalKey,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/template.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    'lib/assets/images/templateLogo.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 135,
                                    height: 135,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: HexColor(containerBorderColor), width: 1),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 5),
                                      ),
                                      child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: topicEntity.imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(
                                              color: HexColor(loadingIndicatorColor),
                                            ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.white,
                                              child: const Icon(
                                                Icons.person,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                    color: HexColor(templateContainerColor1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                  child: Text(
                                    topicEntity.expertName!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3,),
                                Text(
                                  "ReachX Passionate",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: HexColor(templateContainerColor1),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Text(
                                  topicEntity.name.toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: mainFontSize,
                                      fontWeight: FontWeight.bold
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20,),
                                SessionStatusWidget(shareTemplateViewModel: shareTemplateViewModel, sessionEntity: sessionEntity),
                                const SizedBox(height: 15,),
                                SessionFinderWidget(session: sessionEntity,),
                                const SizedBox(height: 15,),
                                Text("www.reachx.pro",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: HexColor(templateContainerColor1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
