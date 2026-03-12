import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/helper/widgets/buildShiningText.dart';
import 'package:reachx_embed/presentation/baseScreens/mentorBaseScreen.dart';
import 'package:reachx_embed/presentation/splashScreen/splashScreenViewModel.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashScreenViewModel _splashScreenViewModel = SplashScreenViewModel();

  @override
  void initState() {
    super.initState();
    navigateToMain();
  }

  void navigateToMain() async {
    globalLoggedIn.value = await _splashScreenViewModel.isLoggedIn();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UpgradeAlert(
              child:  const MentorBaseScreen(),
            ),
          ),
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: MediaQuery.of(context).size.height * 0.2,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "8.2 Billion",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                    "Passions.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold
                  ),
                ),
                RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "One ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: BuildShiningText(
                              text: "You",
                              size: 50,
                            )
                        ),
                        const TextSpan(
                          text: ".",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ]
                    )
                )
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 150,
              height: 5,
              child: LinearProgressIndicator(
                // backgroundColor: HexColor(mainColor),
                color: HexColor(mainColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
