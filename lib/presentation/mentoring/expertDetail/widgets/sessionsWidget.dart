// import 'package:flutter/material.dart';
// import 'package:reachx_embed/commonWidgets/customElevatedButton.dart';
// import 'package:reachx_embed/mentoring/expertDetail/expertDetailViewModel.dart';
//
// class SessionsWidget extends StatelessWidget {
//   ExpertDetailViewModel expertDetailViewModel;
//
//   SessionsWidget({super.key, required this.expertDetailViewModel});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(5)
//       ),
//       child:  Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: 10,
//           children: [
//               CustomElevatedButton(label: "OneToOne", onTap: () {expertDetailViewModel.sessionSwitch(session: "oneToOne");},),
//               CustomElevatedButton(label: "webinar", onTap: () {expertDetailViewModel.sessionSwitch(session: "webinar");}),
//               CustomElevatedButton(label: "Onsite", onTap: () {expertDetailViewModel.sessionSwitch(session: "onsite");}),
//           ],
//         ),
//       ),
//     );
//   }
// }
