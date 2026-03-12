import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
class EventDetailsWidget extends StatefulWidget {

  final Map<String, dynamic> bookingDetails;

  const EventDetailsWidget({super.key, required this.bookingDetails});

  @override
  State<EventDetailsWidget> createState() => _EventDetailsWidgetState();
}

class _EventDetailsWidgetState extends State<EventDetailsWidget> {
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  late double width;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    if(kIsWeb) {
      width = MediaQuery.of(context).size.width * 0.4;
    } else {
      width = MediaQuery.of(context).size.width * 0.75;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: HexColor(containerBorderColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                widget.bookingDetails["name"],
                style: TextStyle(
                  fontSize: 18,
                  color: HexColor(black)
                ),
              ),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar,
                    size: 16,
                    color: HexColor(mainColor),
                  ),
                  const SizedBox(width: 5,),
                  widget.bookingDetails["sessionType"] == 'group'
                      ? Text(
                      _dateAndTimeConvertors.fromUTC(widget.bookingDetails["dateTime"])["date"].toString(),
                  )
                      :  Text(
                    _dateAndTimeConvertors.formatDate(widget.bookingDetails["selectedDate"]),
                    style: TextStyle(
                      fontSize: 13,
                      color: HexColor(secondaryTextColor),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Icon(
                    Iconsax.clock,
                    size: 16,
                    color: HexColor(mainColor),
                  ),
                  const SizedBox(width: 5,),
                  widget.bookingDetails["sessionType"] == 'group'
                    ? Text(
                      _dateAndTimeConvertors.fromUTC(widget.bookingDetails["dateTime"])["time"].toString()
                  )
                      : Text(
                    "${_dateAndTimeConvertors.formatTimeOfDay(widget.bookingDetails["selectedTime"][0])} : ${_dateAndTimeConvertors.formatTimeOfDay(widget.bookingDetails["selectedTime"][1])}",
                    style: TextStyle(
                      fontSize: 13,
                      color: HexColor(secondaryTextColor),
                    ),
                  ),
                ],
              ),
              if(widget.bookingDetails["session"].toLowerCase() == "onsite")
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 16,
                      color: HexColor(mainColor),
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: width,
                      child: Text(
                        widget.bookingDetails["location"],
                        style: TextStyle(
                          fontSize: 13,
                          color: HexColor(secondaryTextColor),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 5,),
              Row(
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        spacing: 2,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.computing,
                            size: 15,
                            color: HexColor(mainColor),
                          ),
                          Text(
                            widget.bookingDetails["session"] == "online" ? "Online Session" : "Offline Session",
                            style: TextStyle(
                              fontSize: 13,
                              color: HexColor(black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        spacing: 2,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.monitor,
                            size: 15,
                            color: HexColor(mainColor),
                          ),
                          Text(
                            widget.bookingDetails["sessionType"] == "oneToOne" ? "1:1" : "Group",
                            style: TextStyle(
                              fontSize: 13,
                              color: HexColor(black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
