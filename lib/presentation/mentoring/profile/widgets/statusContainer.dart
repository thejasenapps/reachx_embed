import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/namingConstants.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/customNetworkAlert.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/helper/networkChecker.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';


class StatusContainer extends StatefulWidget {

  ProfileViewModel profileViewModel;

  StatusContainer({super.key, required this.profileViewModel});

  @override
  State<StatusContainer> createState() => _StatusContainerState();
}

class _StatusContainerState extends State<StatusContainer> {

  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();

  @override
  void initState()  {
    super.initState();
    checkStatus();
    ever(expertRegistrationViewModel.saveResult, (bool isSaved) {
      if(mounted) {
        setState(() {
          status = "online";
        });
      }
    });


    ever(widget.profileViewModel.expert, (bool isExpert) {
      if(mounted) {
        if(isExpert) {
          status = "online";
          setState(() {
            isOnline = true;
          });
        } else {
          status = "offline";
          setState(() {
            isOnline = false;
          });
        }
      }
    });
  }

  Future<void> checkStatus() async {
    bool value = await widget.profileViewModel.isOnline();
    isOnline = value;
    if(isOnline) {
      status = "online";
    } else {
      status = "offline";
    }

  }

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: HexColor(lightBlue)),
          borderRadius: BorderRadius.circular(30)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  isOnline ? "People can reach you now" : "Click to be available",
                  style: TextStyle(
                    fontSize: 11,
                    color: HexColor(black),
                    fontWeight: FontWeight.bold
                  )
              ),
              FlutterSwitch(
                width: 50,
                height: 30,
                inactiveColor: Colors.grey[200]!,
                activeToggleColor: HexColor(mainColor),
                activeColor: HexColor(secondColor),
                inactiveToggleColor: HexColor(mainColor),
                value: isOnline,
                onToggle: (value) async {
                  if(await fetchData()) {
                    if(value) {
                      widget.profileViewModel.assignStatus(context, "online");

                      setState(() {
                        isOnline = true;
                      });
                    } else {
                      bool result = await showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmationBoxWidget(
                                functionality: () {
                                  widget.profileViewModel.assignStatus(context, "offline");
                                  Navigator.pop(context, true);
                                },
                                label: "New bookings will not be available if you are offline.\nAre you sure?"
                            );
                          }
                      );

                      if(result == true) {
                        setState(() {
                          isOnline = false;
                        });
                      } else {
                        setState(() {
                          isOnline = true;
                        });
                      }
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomNetworkAlert();
                        }
                    );
                  }

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
