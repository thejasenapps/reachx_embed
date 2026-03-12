import 'package:flutter/material.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/bookedCardWidget.dart';

class BookingsWidget extends StatelessWidget {

  final List<BookingEntity> bookingsList;
  final BookedViewModel bookedViewModel;

  BookingsWidget({super.key, required this.bookingsList, required this.bookedViewModel});

  String sessionDetail = '';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: bookingsList.length,
          itemBuilder: (context, index) {
            // Convert UTC date-time to local date and time
            var booking = bookingsList[index];

            final isExpert = bookedViewModel.userId == booking.expertId;
            final bookingName = isExpert? booking.attendee.name : booking.expertName;

            if(booking.sessionType!.toLowerCase() == "group" && booking.session!.toLowerCase() == "online") {
              sessionDetail = "webinar";
            } else if(booking.sessionType!.toLowerCase() == "group" && booking.session!.toLowerCase() == "onsite") {
              sessionDetail = "seminar";
            } else if(booking.session!.toLowerCase() == "online") {
              sessionDetail = "Online";
            } else {
              sessionDetail = "Offline";
            }

            return BookedCardWidget(
                bookedViewModel: bookedViewModel,
                booking: booking,
                isExpert: isExpert,
                bookingName: bookingName ?? '',
                sessionDetail: sessionDetail
            );

          }
      ),
    );
  }
}
