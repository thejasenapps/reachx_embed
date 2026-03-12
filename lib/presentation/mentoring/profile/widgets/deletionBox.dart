import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';

class DeletionBoxWidget extends StatefulWidget {
  String label;
  bool isExpert;
  ProfileViewModel profileViewModel;
  DeletionBoxWidget({super.key, required this.label, required this.isExpert, required this.profileViewModel});

  @override
  State<DeletionBoxWidget> createState() => _DeletionBoxWidgetState();
}

class _DeletionBoxWidgetState extends State<DeletionBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            const SizedBox(height: 5,),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Visibility(
              visible: widget.isExpert,
              child: const Text(
                '*If there is any pending meetings, the account will not be deleted',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10,),
            Obx(() {
              if(widget.profileViewModel.isDeleting.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: HexColor(loadingIndicatorColor),
                  ),
                );
              } else {
                return Row(
                  spacing: 30,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if(widget.isExpert) {
                          widget.profileViewModel.checkMeetings(context);
                        } else {
                          widget.profileViewModel.userDelete(context);
                        }
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: HexColor(lightBlue)
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: HexColor(lightBlue)
                        ),
                      ),
                    ),
                  ],
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
