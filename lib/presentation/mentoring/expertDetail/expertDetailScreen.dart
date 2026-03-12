import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customPlaceHolderImage.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/widgets/detailContainerWidget.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';


class ExpertDetailScreen extends StatefulWidget {

  static const route = "/ExpertDetail";

  final Map<String, dynamic> arguments;

  const ExpertDetailScreen({super.key, required this.arguments});

  @override
  State<ExpertDetailScreen> createState() => _ExpertDetailScreenState();
}

class _ExpertDetailScreenState extends State<ExpertDetailScreen> {
  ExpertDetailViewModel expertDetailViewModel = getIt();
  ScrollController scrollController = ScrollController();

  double rating = 0;
  double imageOpacity = 1.0;
  String? userId;

  TopicEntity? topicEntity;

  @override
  void initState() {
    expertDetailViewModel.fetchExpertDetail(widget.arguments["uniqueId"]);

    if(widget.arguments["topic"] == null) {
      expertDetailViewModel.initialTasks( widget.arguments["uniqueId"], widget.arguments["topicId"]);
    } else {
      expertDetailViewModel.initialTasks( widget.arguments["uniqueId"], widget.arguments["topic"].topicId);
    }

    scrollController.addListener(() {
      double offset = scrollController.offset;
      setState(() {
        imageOpacity = (1 - (offset / 100)).clamp(0.0, 1.0);
      });
    });

    super.initState();
  }

  bool interceptor( bool stopDefaultEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if(expertDetailViewModel.isLoading.value) {
        return const Center(child: FlagWavingGif(),);
      } else {
        if (expertDetailViewModel.expertEntity.value == null) {
          return const Scaffold(body: Center(child: Text("No data"),),);
        } else {

          final expertDetails = expertDetailViewModel.expertEntity.value;
          if(widget.arguments["topic"] != null) {
            topicEntity = widget.arguments["topic"];
          } else {
            final topicList = expertDetailViewModel.topicEntity.where((topic) => topic.topicId == widget.arguments["topicId"]);

            if(topicList.isNotEmpty) {
              topicEntity = topicList.first;
            } else {
              return errorBox();
            }
          }

          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackNavigationWidget(context: context),
                        PopupMenuButton(
                            icon: const Icon(
                                Icons.menu
                            ),
                            color: Colors.white,
                            onSelected: (value) {
                              if(value == "report") {
                                expertDetailViewModel.reportUser(context, topicEntity!.expertId!);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: "report",
                                child: Text("Report User"),
                              )
                            ]
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                                color: HexColor(containerColor),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                border: Border.all(
                                    color: HexColor(containerBorderColor),
                                    width: 2
                                )
                            ),
                            width: double.infinity,
                            child: DetailContainerWidget(expertDetailViewModel: expertDetailViewModel, expertEntity: expertDetails!, topicEntity: topicEntity!, userId: widget.arguments["userId"] ?? '', booking: widget.arguments["booking"] ?? '', scrollController: scrollController,),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: -50, // Adjust this value to move it up or down in the container
                          child: Align(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: imageOpacity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child:  CachedNetworkImage(
                                  imageUrl: expertDetails.imageFile,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>  const Center(
                                    child: CustomPlaceHolderImage(),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: HexColor(containerBorderColor)),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(60)
                                      ),
                                      child: const Icon(
                                        Icons.person, size: 40, color: Colors.grey,
                                      )
                                  ),
                                )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    });
  }


  Widget errorBox() {
    return const Scaffold(
      body: Center(
        child: Text("The data is not available"),
      ),
    );
  }
}
