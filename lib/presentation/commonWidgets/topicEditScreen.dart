import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';

class TopicEditScreen extends StatefulWidget {
  static const route = "/topicEditScreen";

  Map<String, dynamic> arguments;

  TopicEditScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<TopicEditScreen> createState() => _TopicEditScreenState();
}

class _TopicEditScreenState extends State<TopicEditScreen> {


  @override
  void initState() {



    widget.arguments["focusNode"].addListener(() {
      if(widget.arguments["title"] == "Update Session Name") {
        widget.arguments["viewModel"].saveTopic("topicName");
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            )
        ),
        title: Text(
          widget.arguments["title"],
          style: const TextStyle(
              fontSize: 22
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            ),
            side: BorderSide(
                color: HexColor(containerBorderColor),
                width: 1
            )
        ),
        backgroundColor: Colors.white,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 100,
            children: [
              widget.arguments["widget"],
              CustomElevatedButton(
                  label: "Save",
                  onTap: () async {
                    Navigator.pop(context);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
