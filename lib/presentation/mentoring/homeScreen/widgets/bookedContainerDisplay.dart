import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedScheduleScreen.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/exploreWidget.dart';

class BookedContainerDisplay extends StatefulWidget {
  final HomeScreenViewModel homeScreenViewModel;
  double phoneHeight;
  ScrollController scrollController;

  BookedContainerDisplay({super.key, required this.homeScreenViewModel, required this.phoneHeight, required this.scrollController});

  @override
  State<BookedContainerDisplay> createState() => _BookedContainerDisplayState();
}

class _BookedContainerDisplayState extends State<BookedContainerDisplay> {
  final BookedViewModel bookedViewModel = getIt();
  final DateAndTimeConvertors dateAndTimeConvertors = DateAndTimeConvertors();



  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookedViewModel.latestBooking.isNotEmpty) {
        setState(() {
          initialIndex = 1;
        });
      }
    });
  }




  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return DefaultTabController(
        length: 2,
        initialIndex: initialIndex,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
                labelColor: HexColor(mainColor),
                unselectedLabelColor: Colors.black,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3, color: HexColor(mainColor)),
                    insets: const EdgeInsets.symmetric(horizontal: 20),
                    borderRadius: BorderRadius.circular(10)
                ),

                dividerHeight: 0,
                tabs: const [
                  Tab(
                    child: Text(
                      "Trending",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Bookings",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 10,),
            Obx(() {
              if(globalTopics.isNotEmpty) {
                return SizedBox(
                  height: 300 + (10000/height),
                  child: TabBarView(
                      children: [
                        ExploreWidget(homeScreenViewModel: widget.homeScreenViewModel,),
                        Obx(() {
                          if(bookedViewModel.latestBooking.isNotEmpty) {
                            return bookingList(bookedViewModel.latestBooking);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                spacing: 20,
                                children: [
                                  const Text(
                                    "Waiting for new bookings",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                          BookedScheduleScreen.route,
                                          id: NavIds.home,
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: HexColor(containerBorderColor),
                                        )
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 10,
                                        children: [
                                          Text(
                                              "Explore past bookings",
                                            style: TextStyle(
                                              color: HexColor(lightBlue)
                                            ),
                                          ),
                                          Icon(
                                            Iconsax.arrow_circle_right,
                                            color: HexColor(mainColor),
                                            size: 18,
                                          )
                                        ],
                                      )
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                      ]
                  ),
                );
              } else {
                return SizedBox(
                  height: 360 + (10000/height),
                  child: TabBarView(
                      children: [
                        ExploreWidget(homeScreenViewModel: widget.homeScreenViewModel,),
                        Obx(() {
                          if(bookedViewModel.latestBooking.isNotEmpty) {
                            return bookingList(bookedViewModel.latestBooking);
                          } else {
                            return Column(
                              children: [
                                const Text(
                                  "Waiting for new bookings",
                                  textAlign: TextAlign.center,
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        BookedScheduleScreen.route,
                                        id: NavIds.home,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: HexColor(containerBorderColor),
                                        )
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10,
                                      children: [
                                        Text(
                                          "Explore past bookings",
                                          style: TextStyle(
                                              color: HexColor(lightBlue)
                                          ),
                                        ),
                                        Icon(
                                          Iconsax.arrow_circle_right,
                                          color: HexColor(mainColor),
                                          size: 18,
                                        )
                                      ],
                                    )
                                )
                              ],
                            );
                          }
                        }),
                      ]
                  ),
                );
              }
            })
          ],
        )
    );
  }


  Widget bookingList(Map<int, dynamic> bookings) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {
              Get.toNamed(
                BookedScheduleScreen.route,
                id: NavIds.home,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                const Text(
                  "Click to see more..",
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
                Icon(
                  Iconsax.arrow_circle_right,
                  color: HexColor(mainColor),
                  size: 18,
                )
              ],
            ),
          )
        ),
        latestBooking(bookings)
      ],
    );
  }


  // Builds the list of latest bookings
  Widget latestBooking(Map<int, dynamic> bookings) {

    List<Widget> bookingWidgets = [];
    for (int i = 0; i < bookings.length && i < 2; i++) {
      var booking = bookings[i];
      if (booking == null) continue;

      // Formatting date and time for display
      var formattedDateTime = dateAndTimeConvertors.fromUTC(booking["dateTime"]);
      final formattedTime = dateAndTimeConvertors.formatTimeOfDay(booking["dateTime"]);
      String timeRange = "$formattedTime - ${dateAndTimeConvertors.addMinutesToTime(formattedDateTime["time"]!, booking["minutes"])}";

      bookingWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Get.toNamed(
                BookedScheduleScreen.route,
                id: NavIds.home,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: HexColor(containerColor),
                  border: Border.all(
                      color: HexColor(containerBorderColor)
                  ),
                  borderRadius: BorderRadius.circular(40)
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor(containerBorderColor),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.person,
                          color: HexColor(lightBlue),
                          size: 22,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: [
                        SizedBox(
                          width: kIsWeb ? 250 : MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            booking["eventName"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Text(
                              timeRange,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: HexColor(lightBlue)),
                            ),
                            Text(
                              "${dateAndTimeConvertors.getWeekday(formattedDateTime["date"]!)} (${dateAndTimeConvertors.getDayFromDate(formattedDateTime["date"]!)})",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: HexColor(lightBlue)),
                            ),
                            if(booking["expert"])
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.star1,
                                    size: 12,
                                    color: HexColor(mainColor),
                                  ),
                                  Text(
                                    "Host",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: HexColor(mainColor)
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(children: bookingWidgets);
  }
}


