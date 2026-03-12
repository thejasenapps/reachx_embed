import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/momentEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/widgets/momentDetailsWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailViewModel.dart';

class MomentsViewScreen extends StatefulWidget {
  static const route = "/momentsView";

  final Map<String, dynamic> arguments;
  const MomentsViewScreen({super.key, required this.arguments});

  @override
  State<MomentsViewScreen> createState() => _MomentsViewScreenState();
}

class _MomentsViewScreenState extends State<MomentsViewScreen> {
  final ScrollController scrollController = ScrollController();

  ExpertDetailViewModel? expertDetailViewModel;

  RxBool get isMomentsLoading =>
      expertDetailViewModel!.isMomentsLoading;

  MomentsEntity? get momentsEntity =>
      expertDetailViewModel!.momentsEntity;
  @override
  void initState() {
    super.initState();

    expertDetailViewModel = widget.arguments["expertDetailViewModel"];

    final topicId = widget.arguments["topicId"];

    if (topicId != null && topicId.isNotEmpty) {
      expertDetailViewModel!.getTreeDetails(topicId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: BackNavigationWidget(context: context),
        title: Text(
          "${widget.arguments["expertName"]}'s Journal",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          side: BorderSide(
            color: HexColor(containerBorderColor),
            width: 1,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/paper.png'),
                fit: BoxFit.cover,
                opacity: 0.2
            )
        ),
        child: Obx(() {
          if (isMomentsLoading.value) {
            return const Center(child: FlagWavingGif());
          }

          if (momentsEntity == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    "The passionate has not yet added his journey",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: scrollController,
            itemCount: momentsEntity!.moments.length,
            itemBuilder: (context, index) {
              return MomentDetailsWidget(
                momentEntity: momentsEntity!.moments[index],
                index: index,
                lastElement: index == momentsEntity!.moments.length - 1,
                topicId: widget.arguments["topicId"],
                topicName: widget.arguments["topicName"],
              );
            },
          );
        }),
      ),
    );
  }
}
