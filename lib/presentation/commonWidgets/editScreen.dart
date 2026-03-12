import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';

class EditScreen extends StatefulWidget {
  static const route = "/editScreen";

  final Map<String, dynamic> arguments;

  const EditScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {


  @override
  void initState() {

    if(widget.arguments["focusNode"] != null) {
      widget.arguments["focusNode"].addListener(() {
        if(widget.arguments["title"] == "Update Name") {
          widget.arguments["viewModel"].saveBasicRegistration("name");
        } else if(widget.arguments["title"] == "Update About") {
          widget.arguments["viewModel"].saveBasicRegistration("about");
        }
      });
    }
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
              Obx(() {
                if(widget.arguments["viewModel"].isEditLoading.value) {
                  return CircularProgressIndicator(
                    color: HexColor(loadingIndicatorColor),
                  );
                } else {
                  return CustomElevatedButton(
                      label: "Save",
                      onTap: () async {
                        if(widget.arguments["title"] == "Update Language"
                            || widget.arguments["title"] == "Update Achievements") {
                          Navigator.pop(context);
                        } else if(widget.arguments["title"] != "Update Achievements") {
                          await widget.arguments["function"]();
                          Navigator.pop(context);
                        }
                      }
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}