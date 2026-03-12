
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customSnackBar.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signBloc.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signEvent.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpForm extends StatefulWidget {
  // Takes AuthenticationType to determine if it's for sign-up or login.
  AuthenticationType type;
  String verificationId;
  bool? isHomeFlow;
  bool? isDiscovery;

  SignUpForm({
    super.key,
    required this.type,
    required this.verificationId,
    required this.isHomeFlow,
    required this.isDiscovery
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  SignUpViewModel signUpViewModel = getIt();

  // Boolean to track if the user agrees to the privacy policy.
  String vid = '';


  final bool _isChecked = false;
  final formKey = GlobalKey<FormState>();
  final CustomSnackBar _customSnackBar = CustomSnackBar();
  String fullNumber = '+91';


  @override
  void initState() {
    super.initState();
  }

  final defaultPinTheme = PinTheme(
    width: 40,
    height: 50,
    textStyle: TextStyle(
      fontSize: 20,
      color: HexColor(lightBlue),
    ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200]
      )
  );


  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          children: [
            Visibility(
              visible: widget.type == AuthenticationType.signup,
              child: customTextFormField(
                  nameController,
                  const Icon(Icons.person_2_outlined),
                  'Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  TextInputType.text
              ),
            ),
            const SizedBox(height: 15,),
            Visibility(
              visible: widget.type == AuthenticationType.signup,
              child: customTextFormField(
                  emailController,
                  const Icon(Icons.mail_outline_rounded),
                  'Email',
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mail';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                  TextInputType.text
              ),
            ),
            const SizedBox(height: 15,),
            customPhone(
                phoneController,
                const Icon(Icons.phone_outlined),
                'Phone Number',
                    (value) {
                  if (value == null) {
                    return 'Please enter your phone number';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                TextInputType.phone
            ),
            // Button to toggle between login and signup screens.
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Visibility(
                visible: widget.verificationId != "",
                child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  controller: signUpViewModel.pinputController,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onCompleted: (verificationCode) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Verifying OTP"),
                      duration: Duration(seconds: 1),
                    )
                  );

                  // Calls the ViewModel to verify the OTP using the provided verification ID.
                  context.read<SignBloc>().add(
                      VerifyOtpEvent(
                          widget.verificationId,
                          verificationCode
                      )
                  );
                },
                ),
              ),
            ),
            const SizedBox(height: 30,),
            signUpViewModel.isLoading
              ? Center(
              child: Column(
                spacing: 2,
                children: [
                  Text(
                    "Just a moment!\nReachX is making sure you're genuine passionate, not spam.\nIt may take a few seconds..",
                    style: TextStyle(
                      color: HexColor(lightBlue),
                      fontSize: 12
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CircularProgressIndicator(
                    color: HexColor(lightBlue),
                  ),
                ],
              ),
            )
              : Visibility(
                visible: widget.verificationId == "",
                child: CustomElevatedButton(
                    label: widget.type == AuthenticationType.login ? 'Login'
                        : widget.isDiscovery != null ? 'Discover' : 'Sign Up',
                    onTap: () {
                      if(formKey.currentState!.validate()) {
                        final phoneNumber = '$fullNumber${phoneController.text}';
                        context.read<SignBloc>().add(
                            SubmitFormEvent(
                                nameController.text,
                                phoneNumber,
                                emailController.text,
                                context
                            )
                        );
                        setState(() {
                          signUpViewModel.isLoading = true;
                        });
                      }
                    }
                )
            ), const SizedBox(height: 50,),
            TextButton(
              onPressed: () {

                if(mounted) {
                  if(widget.type == AuthenticationType.login) {
                    // if(widget.isHomeFlow != null && widget.isHomeFlow == true) {
                    //   if(mounted) {
                    //     Get.offNamed(
                    //       preventDuplicates: false,
                    //       SignUpScreen.route,
                    //       arguments: {
                    //         "type": AuthenticationType.signup,
                    //         "isHomeFlow": widget.isHomeFlow
                    //       },
                    //     );
                    //   }
                    // } else {
                    //   // Navigator.pop(context);
                    //   // //
                    //   // // Get.until((route) => route.settings.name == HomeScreen.route,
                    //   // //   id: NavIds.home,
                    //   // // );
                    //   //
                    //   // // Get.back();
                    //   // // toDiscover.value = !toDiscover.value;
                    //   //
                    //   //
                    //   // Get.toNamed(
                    //   //     preventDuplicates: true,
                    //   //     PassionQuestionnaireScreen.route,
                    //   //     id: NavIds.discover
                    //   // );
                    //
                    //   WidgetsBinding.instance.addPostFrameCallback((_) {
                    //     Get.offNamed(
                    //         preventDuplicates: false,
                    //         SignUpScreen.route,
                    //         arguments: {
                    //           "type": AuthenticationType.signup,
                    //           "isHomeFlow": widget.isHomeFlow
                    //         }
                    //     );
                    //   });
                    // }

                      // if(mounted) {
                      //   Get.offNamed(
                      //     preventDuplicates: false,
                      //     SignUpScreen.route,
                      //     arguments: {
                      //       "type": AuthenticationType.signup,
                      //       "isHomeFlow": widget.isHomeFlow
                      //     },
                      //   );
                      // }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Get.offNamed(
                            preventDuplicates: false,
                            SignUpScreen.route,
                            arguments: {
                              "type": AuthenticationType.signup,
                              "isHomeFlow": widget.isHomeFlow
                            }
                        );
                      });
                  } else {
                    nameController.clear();
                    emailController.clear();

                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     Get.offNamed(
                         preventDuplicates: false,
                         SignUpScreen.route,
                         arguments: {
                           "type": AuthenticationType.login,
                           "isHomeFlow": widget.isHomeFlow
                         }
                     );
                   });
                  }
                }
              },
              child: widget.type == AuthenticationType.login
                  ? Column(
                children: [
                  const Text(
                    "If you are a new user,",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                    Text(
                     "Click here to sign up",
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: HexColor(mainColor),
                    ),
                  ),
                ],
              )
                  :  Column(
                children: [
                  const Text(
                    "If you already have an account",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Click here to login",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: HexColor(mainColor),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextFormField(TextEditingController textController, Icon icon, String label, FormFieldValidator validation, TextInputType keyboardType) {
    return TextFormField(
      controller: textController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor: HexColor(black),
        labelText: label,
        labelStyle: TextStyle(
          color: HexColor(secondaryTextColor),
          fontSize: 14
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorMaxLines: 2,
        constraints: const BoxConstraints(minHeight: 60, maxHeight: 60),
      ),
      validator: validation,
    );
  }

  Widget customPhone(TextEditingController textController, Icon icon, String label, FormFieldValidator validation, TextInputType keyboardType) {
    return IntlPhoneField(
      controller: textController,
      keyboardType: keyboardType,
      disableLengthCheck: true,
      showCountryFlag: false,
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        labelStyle: TextStyle(
            color: HexColor(secondaryTextColor),
            fontSize: 14
        ),
      ),
      initialCountryCode: 'IN',
      onCountryChanged: (code) {
        fullNumber = '+${code.dialCode}';
      },
    );
  }
}
