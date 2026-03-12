import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/constants/rescheduleStatus.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/leftColumnWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/rightColumnWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupScreen.dart';

class BookedCardWidget extends StatelessWidget {
  final BookingEntity booking;
  final BookedViewModel bookedViewModel;
  final bool isExpert;
  final String bookingName;
  final String sessionDetail;

  const BookedCardWidget({
    super.key,
    required this.bookedViewModel,
    required this.booking,
    required this.isExpert,
    required this.bookingName,
    required this.sessionDetail,

  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        Get.toNamed(
            MeetingSetupScreen.route,
            arguments: {
              "booking": booking,
              "isExpert": isExpert,
              "groupBooking": booking.groupIds != null && booking.groupIds!.isNotEmpty
                  ? bookedViewModel.groupEntity : null
            },
            id: NavIds.home
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HexColor(containerBorderColor)),
            color: Colors.white,

          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              spacing: 10,
              children: [
                // Displaying booking details (expert name, description, event name, etc.)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LeftColumnWidget(
                        booking: booking,
                        bookedViewModel: bookedViewModel,
                        isExpert: isExpert,
                        bookingName: bookingName,
                        sessionDetail: sessionDetail
                    ),
                    RightColumnWidget(
                        bookingEntity: booking,
                        isExpert: isExpert
                    )
                  ],
                ),
                // Action buttons (Remind, Reschedule, Cancel)
                booking.rescheduleStatus == RescheduleStatus.started
                    ?  booking.expertId == bookedViewModel.userId
                    ? const Text("Waiting for reschedule confirmation")
                    : const Text("Reschedule alert from passionate")
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
