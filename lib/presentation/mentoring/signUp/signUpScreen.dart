import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreen.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signBloc.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signState.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/widgets/signUpForm.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListScreen.dart';



class SignUpScreen extends StatefulWidget {
  static const route = '/SignUpScreen';

  Map<String, dynamic> arguments;

  SignUpScreen({
    super.key,
    required this.arguments
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  SignUpViewModel signUpViewModel = getIt();


  List<String> docIds = [];
  String verificationId = '';

  @override
  void initState() {
    super.initState();
    getIds();
    updateName();
    BackButtonInterceptor.add(interceptor);
  }

  void getIds() async {
    docIds = await _getFromFirestore.getAllIds("experts");
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    if(widget.arguments["isHomeFlow"] == null) {
      activatePopup.value = true;
    }
    Get.back();


    return true;
  }

  void updateName() {
    if(widget.arguments["name"] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.text = widget.arguments["name"];
      });
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener <SignBloc, SignState>(
      listener: (context, state) {
        if(state is OtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Otp sent"))
          );
          setState(() {
            verificationId = state.verificationId;
            signUpViewModel.isLoading = false;
          });
        } else if(state is SignUpError) {
          if(state.message == "SignIn details not found") {

            setState(() {
              widget.arguments["type"] = AuthenticationType.signup;
            });
          } else if(state.message == "Details found. SignIn to continue") {
            setState(() {
              widget.arguments["type"] = AuthenticationType.login;
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message))
          );

          setState(() {
            signUpViewModel.isLoading = false;
          });
        } else if(state is OtpVerified) {
          String firebaseUid = state.uid;
          bool isExpert = docIds.contains(firebaseUid);
          globalUserId.value = state.uid;
          globalLoggedIn.value = true;

          Navigator.pop(context);
          signal.value = true;

          if(checkpoint == "homeScreen") {
            // Navigate to expert registration if checkpoint matches.
            Get.toNamed(
                HomeScreen.route,
                id: NavIds.home
            );

            Get.toNamed(
              TopicListScreen.route,
              arguments: null,
              id: NavIds.home,
            );

            signUpViewModel.broadCastLogin();
            // if(!isExpert) {
            //   Get.toNamed(
            //       ExpertRegistration.route,
            //       arguments: {
            //         "isRegistration": true,
            //       },
            //       id: NavIds.home
            //   );
            // } else {
            //   signUpViewModel.broadCastLogin();
            // }
          } else {
            // Broadcast login response if checkpoint is different.
            signUpViewModel.broadCastLogin();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 15),
                  child: BackNavigationWidget(context: context)
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                     mainAxisSize: MainAxisSize.min, // Centers content vertically.
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 25,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor(lightBlue), width: 2),
                            color: Colors.white,
                            shape: BoxShape.circle
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  'lib/assets/images/reachX_icon.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Displays the sign-up or login form based on the `type`.
                        SignUpForm(
                          type: widget.arguments["type"] ?? AuthenticationType.login,
                          verificationId: verificationId,
                          isHomeFlow: widget.arguments["isHomeFlow"],
                          isDiscovery: widget.arguments["discovery"],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
