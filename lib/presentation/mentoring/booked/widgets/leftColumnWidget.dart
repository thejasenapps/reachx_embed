import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/navigation/navigationController.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/customSecondaryTextWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';

class LeftColumnWidget extends StatelessWidget {
  final BookingEntity booking;
  final BookedViewModel bookedViewModel;
  final bool isExpert;
  final String bookingName;
  final String sessionDetail;


  const LeftColumnWidget({
    super.key,
    required this.booking,
    required this.bookedViewModel,
    required this.isExpert,
    required this.bookingName,
    required this.sessionDetail
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        booking.sessionType!.toLowerCase() == "group"
            && bookedViewModel.userId == booking.expertId
            ? Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: customBoldText(
              booking.session!.toLowerCase() == "online"
                  ? "Webinar": "Seminar", isExpert
              : isExpert),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            GestureDetector(
                onTap: () {
                  if(!isExpert) {
                    Map<String, dynamic> arguments = {
                      "uniqueId": booking.expertId,
                      "topicId":booking.topicId,
                      "userId": bookedViewModel.userId,
                      "booking": "upcoming"
                    };

                    Get.toNamed(
                        ExpertDetailScreen.route,
                        id: NavIds.home,
                        arguments: arguments
                    );
                    NavigationController.to.changePage(NavIds.home);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You are the passionate"))
                    );
                  }
                },
                child: customBoldText(bookingName, isExpert: isExpert)
            ),
            RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "(",
                          style: TextStyle(
                              color: HexColor(lightBlue),
                              fontSize: 12
                          )
                      ),
                      TextSpan(
                          text: booking.sessionType?.toLowerCase() == "group"
                              ? booking.session?.toLowerCase() == "online"
                              ? "Webinar"
                              : "Seminar"
                              : isExpert ? "Attendee" : "Host",
                          style: TextStyle(
                              color: HexColor(secondaryTextColor),
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          )
                      ),
                      TextSpan(
                          text: ")",
                          style: TextStyle(
                              color: HexColor(lightBlue),
                              fontSize: 12
                          )
                      ),
                    ]
                )
            ),
          ],
        ),
        const SizedBox(height: 5,),
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Iconsax.menu_board,
              color: HexColor(lightBlue),
              size: 18,
            ),
            SizedBox(
              width: 150,
              child: Text(
                booking.eventName!,
                style: TextStyle(
                    fontSize: 14,
                    color: HexColor(secondaryTextColor)
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        if(booking.sessionType!.toLowerCase() != "group")
          CustomSecondaryTextWidget(
              text: sessionDetail,
              icon: Iconsax.activity
          ),
        if(booking.sessionType!.toLowerCase() == "group" && isExpert)
          CustomSecondaryTextWidget(
              text: booking.groupIds!.length > 1
                  ? "${booking.groupIds!.length} people"
                  : "${booking.groupIds!.length} person",
              icon: Iconsax.people
          )
      ],
    );
  }


  Widget customBoldText(text, {bool isExpert = true}) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: HexColor(lightBlue)
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
