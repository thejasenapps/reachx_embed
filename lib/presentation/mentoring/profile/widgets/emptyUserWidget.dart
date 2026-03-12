import 'package:flutter/material.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';

class EmptyUserWidget extends StatelessWidget {
  final ProfileViewModel profileViewModel;

  const EmptyUserWidget({super.key, required this.profileViewModel});


  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Text(
            "You must login to see your profile"
          )
        ],
      )
    );
  }
}
