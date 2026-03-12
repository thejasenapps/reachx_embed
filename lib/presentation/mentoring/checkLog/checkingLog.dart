import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/checkLog/checkingLogViewModel.dart';


class CheckingLog extends StatefulWidget {

  static const route = '/CheckLog';  // Route name for navigating to CheckingLog screen.

  const CheckingLog({super.key});

  @override
  State<CheckingLog> createState() => _CheckingLogState();
}

class _CheckingLogState extends State<CheckingLog> {

  @override
  void initState() {
    // Calls the checkUserStatus method from CheckingLogViewModel when the screen is initialized.
    CheckingLogViewModel().checkUserStatus(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: HexColor(loadingIndicatorColor),
        ),
      ),
    );
  }
}
