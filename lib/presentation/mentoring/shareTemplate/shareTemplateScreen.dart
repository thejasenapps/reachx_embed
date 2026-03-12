import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/findPlatform.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/shareTemplateViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/widgets/posterTemplateWidget.dart';


class ShareTemplateScreen extends StatefulWidget {
  static const route = "/shareTemplate";
  
  Map<String, dynamic> arguments;
  ShareTemplateScreen({super.key, required this.arguments});

  @override
  State<ShareTemplateScreen> createState() => _ShareTemplateScreenState();
}

class _ShareTemplateScreenState extends State<ShareTemplateScreen> {

  final ShareTemplateViewModel shareTemplateViewModel = ShareTemplateViewModel();


  @override
  void initState() {
    BackButtonInterceptor.add(interceptor);
    super.initState();
  }

  bool interceptor( bool stopDefaultEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    double containerHeight = findPlatform();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    border: Border.all(
                        color: HexColor(containerBorderColor)
                    )
                ),
                height: containerHeight,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        child: BackNavigationWidget(context: context),
                      ),
                      const Text(
                        "Share session",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.white),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: HexColor(lightBlue),
                                            width: 1.5
                                        )
                                    )
                                )
                            ),
                            onPressed: () => shareTemplateViewModel.captureAndShare(widget.arguments["topicEntity"], context),
                            child: const Text(
                              "Share",
                              style: TextStyle(
                                  color: Colors.black
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PosterTemplateWidget(
                  shareTemplateViewModel: shareTemplateViewModel,
                  topicEntity: widget.arguments["topicEntity"],
                  sessionEntity: widget.arguments["sessionEntity"]
              )
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: WidgetStateProperty.all(Colors.white),
                //         shape: WidgetStateProperty.all(
                //             RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(20),
                //                 side: BorderSide(
                //                     color: HexColor(lightBlue),
                //                     width: 1.5
                //                 )
                //             )
                //         )
                //     ),
                //     onPressed: () => shareTemplateViewModel.captureAndShare(widget.arguments["topicEntity"]),
                //     child: const Text(
                //       "Share",
                //       style: TextStyle(
                //           color: Colors.black
                //       ),
                //     )
                // ),
                SizedBox(height: 130,)
              ],
            ),
          ),
        ],
      ),
    );
  }

}
