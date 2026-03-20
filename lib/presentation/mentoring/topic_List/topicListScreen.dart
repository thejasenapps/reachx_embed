import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/widgets/searchWidget.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/widgets/topicListFilesWidget.dart';



class TopicListScreen extends StatefulWidget {

  static const route = '/topicList';

  String? searchItem;

  TopicListScreen({super.key, this.searchItem});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen>  with WidgetsBindingObserver {
  TopicListViewModel topicListViewModel = TopicListViewModel();

  @override
  void initState() {
    if(widget.searchItem != null) {
      topicListViewModel.searchController.text = widget.searchItem!;
    }
    BackButtonInterceptor.add(interceptor);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  bool interceptor( bool stopDefaultEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeMetrics() {
    final bottomSheet = WidgetsBinding.instance.window.viewInsets.bottom;
    final isKeyboardVisible = bottomSheet > 0.0;
    topicListViewModel.isKeyboardOpen.value = isKeyboardVisible;
  }

  @override
  Widget build(BuildContext context) {
    // If a search item is provided, set the search controller’s text.

    var baseHeight = MediaQuery.of(context).size.height;
    var baseWeight = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: HexColor(secondaryBackgroundColor),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: baseHeight * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 5,
                  offset: const Offset(0, 3)
                )
              ]
            ),
            child: Padding(
              padding:  EdgeInsets.only(top: baseHeight * 0.08, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .start,
                children: [
                  SizedBox(
                      height: 60,
                      child: BackNavigationWidget(context: context)
                  ),
                  SearchWidget(topicListViewModel: topicListViewModel),
                  const SizedBox(width: 40,)
                ],
              ),
            ),
          ),
          // Ensures TopicListFilesWidget takes available vertical space.
          Expanded(
            child: SizedBox(
                width: baseWeight * 0.95,
                child: TopicListFilesWidget(
                  topicListViewModel: topicListViewModel,
                  searchItem: widget.searchItem ?? '',
                )
            ),
          ),
        ],
      ),
    );
  }
}
