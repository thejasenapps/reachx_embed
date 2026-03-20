import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/domain/sessionDetail/sessionDetailusecase.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booking/bookingDialogScreen.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SessionDetailViewModel extends GetxController {

  SessionDetailUsecase sessionDetailUsecase = SessionDetailUsecase();
  DateAndTimeConvertors dateAndTimeConvertors = DateAndTimeConvertors();

  List<TimeOfDay> scheduledTime = [];
  List<Appointment> appointments = <Appointment>[];
  int noOfGroupSlots = 1;

  RxString selectedDate = ''.obs;
  RxBool isLoading = false.obs;


  // Converts time string to TimeOfDay object.
  TimeOfDay stringToTime(String time) {
    final period = time.split(' ').last.toLowerCase();
    final parts = time.split(' ')[0].split(':');
    int hour = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    if (period == 'pm' && hour != 12) {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minutes);
  }


  // Updates selected date and time when a slot is tapped.
  void onTapped(String date, DateTime start, DateTime end) {
    selectedDate.value = date;
    scheduledTime = [
      TimeOfDay(hour: start.hour, minute: start.minute),
      TimeOfDay(hour: end.hour, minute: end.minute)
    ];
  }

  // Clears the selected date and scheduled time.
  void onCleared() {
    selectedDate.value = '';
    scheduledTime.clear();
  }


  // Fetches available session slots for a given event type and duration.
  void getSlots(int eventTypeId, int minutes) async {

    isLoading.value = true;

    SlotEntity slotEntity = await sessionDetailUsecase.getSlots(eventTypeId);
    appointments.clear();
    slotEntity.slotsByDate.forEach((date, slots) {

      for(String slot in slots) {
        DateTime start = DateTime.parse(slot);
        appointments.add(
          Appointment(
              startTime: start.toLocal(),
              endTime: start.toLocal().add(Duration(minutes: minutes)),
              subject: "Available",
              isAllDay: false
          )
        );
      }
    });
    isLoading.value = false;

  }


  // Returns an AppointmentDataSource with the fetched appointment slots.
  AppointmentDataSource getSlotSource() {
    AppointmentDataSource appointmentDataSource = AppointmentDataSource(appointments);
    return appointmentDataSource;
  }


  // Confirms the booking process and navigates to the booking dialog or login page if necessary.
  void confirmBooking(BuildContext context, Map<String, dynamic> bookingDetails) async {
    Map<String, dynamic>? bookingBill;

    if(bookingDetails["sessionType"] != "group") {
      bookingBill = Map.from(bookingDetails)
        ..addAll({
          "selectedDate": selectedDate.value,
          "selectedTime": scheduledTime,
        });
    } else {
      bookingBill = Map.from(bookingDetails)
          ..addAll({
            "slotsBooked": noOfGroupSlots,
          });
      bookingBill["rate"] = bookingBill["rate"] * noOfGroupSlots;
    }

    bool result = await sessionDetailUsecase.getLog("loggedIn");
    if(!result && !signal.value) {
      checkpoint = "sessionDetail";
      Get.toNamed(
          SignUpScreen.route,
          arguments: {
            "type": AuthenticationType.login,
            "isHomeFlow": true
          },
          id: NavIds.home
      );
    } else {
      Get.toNamed(
        BookingDialogScreen.route,
        arguments: bookingBill,
        id: NavIds.home
      );
    }
  }
}


// Data source class for handling calendar appointments.
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
