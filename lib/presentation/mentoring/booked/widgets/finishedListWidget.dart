 import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/navigation/navigationController.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';

class FinishedListWidget extends StatefulWidget {

  final BookedViewModel bookedViewModel;

  const FinishedListWidget({super.key, required this.bookedViewModel});

  @override
  State<FinishedListWidget> createState() => _FinishedListWidgetState();
}

class _FinishedListWidgetState extends State<FinishedListWidget> {
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  @override
  Widget build(BuildContext context) {

    List<BookingEntity> bookingsList = widget.bookedViewModel.finishedEntity;

    return widget.bookedViewModel.userId == null
        ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              spacing: 40,
              children: [
                const Text(
                  "Login to see your finished bookings",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
                CustomElevatedButton(
                    label: "Login",
                    onTap: () {
                      NavigationController.to.changePage(NavIds.bookings);
                      checkpoint = "profile";
                      Get.toNamed(
                        SignUpScreen.route,
                        arguments: {
                          "type": AuthenticationType.login
                        },
                        id: NavIds.home
                      );
                    }
                )
              ],
            ),
          ),
        )
        : bookingsList.isEmpty
        ? const Center(child: Text("No finished bookings"),)
        : Expanded(
      child: ListView.builder(
          itemCount: bookingsList.length,
          itemBuilder: (context, index) {
            // Convert UTC date-time to local date and time
            final formattedDateTime = _dateAndTimeConvertors.fromUTC(bookingsList[index].start);
            var booking = bookingsList[index];

            if(booking.rescheduleStatus == "finished") {
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: HexColor(containerBorderColor)),
                        color: HexColor(backgroundContainerColor),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customBoldText(booking.expertName!),
                                const SizedBox(height: 5),
                                customSecondaryText("Topic: ${booking.eventName!}"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customBoldText("${formattedDateTime["date"]!} (${_dateAndTimeConvertors.getDayFromDate(formattedDateTime["date"]!)})"),
                                customSecondaryText("Time: ${formattedDateTime["time"]}"),
                                const SizedBox(height: 5,),
                                Visibility(
                                  visible: booking.reviewRating != 0,
                                  child: Row(
                                    children: [
                                      const Text("Rating:"),
                                      StarRating(
                                        rating: booking.reviewRating!,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget customBoldText(text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget customSecondaryText(text) {
    return SizedBox(
      width: 120,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            color: HexColor(secondaryTextColor)
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
