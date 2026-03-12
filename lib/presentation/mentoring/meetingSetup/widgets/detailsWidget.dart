import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';

class DetailsWidget extends StatelessWidget {

  BookingEntity bookingEntity;
  List<BookingEntity> groupEntity;
  bool isExpert;
  DetailsWidget({super.key, required this.bookingEntity, required this.groupEntity, required this.isExpert});

  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();
  String sessionStatus = '';

  int index = 1;


  @override
  Widget build(BuildContext context) {

    Map<String, String> dateAndTime = _dateAndTimeConvertors.fromUTC(bookingEntity.start);
    final formattedTime = _dateAndTimeConvertors.formatTimeOfDay(bookingEntity.start);

    if(bookingEntity.sessionType!.toLowerCase() == "group" && bookingEntity.session!.toLowerCase() == "online") {
      sessionStatus = "Webinar";
    } else if(bookingEntity.sessionType!.toLowerCase() == "group" && bookingEntity.session!.toLowerCase() == "offline") {
      sessionStatus = "Seminar";
    } else if(bookingEntity.sessionType!.toLowerCase() == "1:1" && bookingEntity.session!.toLowerCase() == "online") {
      sessionStatus = "Online 1:1 session";
    } else {
      sessionStatus = "Offline 1:1 session";
    }





    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleContainer(),
        Text(
          bookingEntity.expertName!,
          style: TextStyle(
              fontSize: 16,
              color: HexColor(lightBlue)
          ),
        ),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              spacing: 5,
              children: [
                Icon(
                  Iconsax.calendar,
                  size: 14,
                  color: HexColor(mainColor),
                ),
                Text(
                  "${dateAndTime["date"]!}  (${_dateAndTimeConvertors.getDayFromDate(dateAndTime["date"]!)})",
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                Icon(
                  Iconsax.clock,
                  size: 14,
                  color: HexColor(mainColor),
                ),
                Text(
                  formattedTime,
                  style: const TextStyle(
                      fontSize: 14,
                      color:  Colors.grey
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            bookingEntity.sessionType!.toLowerCase() == "group"
            ? sessionContainer("Webinar")
            : sessionContainer("Online 1:1"),
          ] ,
        ),
        if(bookingEntity.sessionType!.toLowerCase() == "group" && groupEntity.isNotEmpty && isExpert)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                const Text("Attendees:"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: groupEntity.where((groupBooking) => groupBooking.topicId == bookingEntity.topicId)
                        .map((groupEntity) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text("${index++}"),
                              Text(groupEntity.attendee.name)
                            ],
                          );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget titleContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        bookingEntity.eventName!,
        style: TextStyle(
          fontSize: 22,
          color: HexColor(lightBlue)
        ),
      ),
    );
  }
  
  
  Widget sessionContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Icon(
              Iconsax.computing,
              color: HexColor(mainColor),
              size: 12,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customText(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: HexColor(black)
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 15,
              color: HexColor(lightBlue)
          ),
        ),
      ],
    );
  }
}
