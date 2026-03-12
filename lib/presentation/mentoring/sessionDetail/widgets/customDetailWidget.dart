import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomDetailWidget extends StatelessWidget {

  Map<String, dynamic> bookingDetails;
  CustomDetailWidget({super.key, required this.bookingDetails});

  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> dateTime = _dateAndTimeConvertors.fromUTC(bookingDetails["dateTime"]);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor(containerBorderColor)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                bookingDetails["name"]
            ),
            Text(
              bookingDetails["expertName"],
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
                      dateTime["date"],
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
                      _dateAndTimeConvertors.formatTimeOfDay(dateTime["time"]),
                      style: const TextStyle(
                          fontSize: 14,
                          color:  Colors.grey
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
