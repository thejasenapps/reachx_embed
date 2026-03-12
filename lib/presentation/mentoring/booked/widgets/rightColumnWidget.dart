import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/dotGenerator.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/customSecondaryTextWidget.dart';

class RightColumnWidget extends StatelessWidget {
  final bool isExpert;
  final BookingEntity bookingEntity;

  RightColumnWidget({
    super.key,
    required this.bookingEntity,
    required this.isExpert
  });

  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = _dateAndTimeConvertors.fromUTC(bookingEntity.start);
    final time = _dateAndTimeConvertors.formatTimeOfDay(bookingEntity.start);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 5,
      children: [
        Row(
          spacing: 5,
          children: [
            DotWidget(size: 8, color: isExpert ? HexColor(mainColor) : HexColor(secondaryTextColor),),
            Text(
              "You",
              style: TextStyle(
                  fontSize: 14,
                  color: HexColor(lightBlue),
                  fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
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
                      text: isExpert ? "Host" : "Attendee",
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
        const SizedBox(height: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            CustomSecondaryTextWidget(
              text: "${_dateAndTimeConvertors.getWeekday(formattedDateTime["date"]!)} (${_dateAndTimeConvertors.getDayFromDate(formattedDateTime["date"]!)})",
              icon: Iconsax.calendar,
            ),
            CustomSecondaryTextWidget(
                text: "Time: $time",
                icon: Iconsax.clock
            )
          ],
        )
      ],
    );
  }
}
