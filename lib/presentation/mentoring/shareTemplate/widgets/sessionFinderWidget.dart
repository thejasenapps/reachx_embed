import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/weekSummarizer.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';

class SessionFinderWidget extends StatelessWidget {
  SessionEntity session;
  SessionFinderWidget({super.key, required this.session});

  final WeekSummarizer _weekSummarizer = WeekSummarizer();
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();


  String locationModifier(String location) {
    final parts = location.split(",");
    return "${parts[0]},${parts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    if(session.sessionType == "1:1") {
      List weekDays = _weekSummarizer.summarizeWeekdays(session.weekdays!, 1);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          customText(Iconsax.clock, "${_dateAndTimeConvertors.formatTimeOfDay(session.timeInterval![0])} to ${_dateAndTimeConvertors.formatTimeOfDay(session.timeInterval![1])}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              const Icon(
                Iconsax.calendar_1 ,
                size: 15,
              ),
              SizedBox(
                height: 20,
                child: ListView.builder(
                    itemCount: weekDays.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Text(
                          "${weekDays[index]} ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
          if(session.session.toLowerCase() == "onsite")
            customText(Iconsax.location, locationModifier(session.location!))
        ],
      );
    } else if(session.sessionType == "Group" ) {

      final dateTime = _dateAndTimeConvertors.fromUTC(session.dateTime!);
      final initialTime = _dateAndTimeConvertors.formatTimeOfDay(dateTime["time"]);
      final finalTime = _dateAndTimeConvertors.addMinutesToTime(dateTime["time"]!, 60 * (session.selectedHours ?? 1));

      return Column(
        children: [
          customText(Iconsax.calendar, _dateAndTimeConvertors.formatDate(dateTime["date"]!)),
          customText(Iconsax.clock, " $initialTime - $finalTime"),
          if(session.session.toLowerCase() == "onsite")
            customText(Iconsax.location, locationModifier(session.location!))
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget customText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Icon(
          icon,
          size: 15,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
