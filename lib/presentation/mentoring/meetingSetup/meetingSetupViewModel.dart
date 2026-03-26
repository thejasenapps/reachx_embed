import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/meetingTypes.dart';
import 'package:reachx_embed/core/constants/rescheduleStatus.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/helper/stringEditors.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';
import 'package:reachx_embed/domain/meetingSetup/meetingSetupUsecase.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/sessionDetailViewModel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingSetupViewModel {

  final MeetingSetupUsecase _meetingSetupUsecase = MeetingSetupUsecase();
  final StringEditors _stringEditors = StringEditors();
  final BookedViewModel bookedViewModel = getIt();

  List<Appointment> appointments = <Appointment>[];
  DateTime? selectedDate;
  List<TimeOfDay> selectedTime = [];
  String meetUrl = '';
  String? userId;
  BookingEntity? bookingEntity;
  List<BookingEntity> groupEntities = [];
  bool isExpert = false;
  List<String> guidelines = [];

  RxBool isAvailable = false.obs;
  RxBool rescheduleNotify = false.obs;
  RxBool cancelled = false.obs;
  RxBool isLoading = false.obs;
  RxBool isGuidelinesLoading = false.obs;
  RxList<String> passingDeleteIds = <String>[].obs;

  TextEditingController meetingUrlController = TextEditingController();


  DateTime activeTiming(String start) {
    DateTime dateTime = DateTime.parse(start).toUtc();
    DateTime activeTime = dateTime.subtract(const Duration(minutes: 10));

    return activeTime;
  }

  void beginMeeting(List<String> bookingIds, String meetingUrl) {
    _meetingSetupUsecase.meetingInitiated(MeetingTypes.finished, bookingIds, meetingUrl);
    launchMeet(meetingUrl);
  }


  void launchMeet(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }


  Future<String> saveUrl(List<String> bookingIds, String meetingUrl, String topicId, String sessionType) async {

    String finalUrl = _stringEditors.httpsAdder(meetingUrl);
    meetUrl = finalUrl;
    bool result = await _meetingSetupUsecase.saveMeetingUrl(
        finalUrl,
        bookingIds,
        topicId,
        sessionType
    );

    String text = "";
    if(result) {
      text = "Successfully saved";
    } else {
      text = "Failed saving";
    }
    return text;
  }


  void onTapped(BookingEntity booking) async {
    isLoading.value = true;
    userId = await FirebaseAuthentication().getFirebaseUid();

    if (userId != null) {
      RescheduleEntity rescheduleEntity = RescheduleEntity(
          rescheduleProgress: RescheduleStatus.started,
          bookingId: booking.bookingUniqueId!,
          rescheduleInitiatorId: userId!,
          timestamp: DateTime.now()
      );

      bool result = await _meetingSetupUsecase.rescheduleStatusChange(rescheduleEntity);

      if (result) {
        rescheduleNotify.value = !rescheduleNotify.value;
        _meetingSetupUsecase.sendRescheduleNotification(
          booking.expertId!,
          booking.attendeeId!,
          RescheduleStatus.started,
          booking.eventName!,
        );
      }

      isLoading.value = false;
    }
  }

  Future<void> rescheduleConfirmation(DateTime date, BookingEntity bookingEntity, String rescheduleStatus) async {
    isLoading.value = true;
    userId = await FirebaseAuthentication().getFirebaseUid();

    if (userId != null) {
      RescheduleEntity rescheduleEntity = RescheduleEntity(
          rescheduleProgress: RescheduleStatus.activated,
          bookingId: bookingEntity.bookingUniqueId!,
          rescheduleInitiatorId: userId!,
          timestamp: DateTime.now()
      );

      final response = await Future.wait([
        _meetingSetupUsecase.rescheduleStatusChange(rescheduleEntity),
        _meetingSetupUsecase.rescheduleBooking(date.toUtc().toIso8601String(), bookingEntity.bookingUniqueId!)
      ]);

      if (response[1] is SuccessState) {
        await _meetingSetupUsecase.sendRescheduleNotification(
          bookingEntity.expertId!,
          bookingEntity.attendeeId!,
          RescheduleStatus.started,
          bookingEntity.eventName!,
        );
        rescheduleNotify.value = !rescheduleNotify.value;
        bookedViewModel.getSessionsBookings();
      }
    }

    isLoading.value = false;
  }

  void updateStatus(BookingEntity bookingEntity, String rescheduleStatus, BuildContext context, {String id = 'nil'}) async {
    bool result = await _meetingSetupUsecase.statusUpdate(rescheduleStatus, bookingEntity.bookingUniqueId!, id: id);

    if (result) {
      _meetingSetupUsecase.sendRescheduleNotification(
        bookingEntity.expertId!,
        bookingEntity.attendeeId!,
        RescheduleStatus.started,
        bookingEntity.eventName!,
      );
      rescheduleNotify.value = true;
      bookedViewModel.getSessionsBookings();
    }
  }

  Future<bool> cancel(
      BookingEntity bookingEntity,
      List<String> bookingUniqueIds,
      List<int> bookingIds,
      BuildContext context,
      ) async {
    Results results = await _meetingSetupUsecase.cancelBooking(
      bookingUniqueIds,
      bookingIds,
      bookingEntity.sessionType!,
    );

    if (results is SuccessState) {
      // bookedViewModel.getSessionsBookings();
      // cancelled.value = !cancelled.value;
      passingDeleteIds.value = bookingUniqueIds;
      return true;
    }
    return false;
  }

  void getSlots(int eventTypeId, int minutes) async {
    isAvailable.value = false;
    SlotEntity slotEntity = await _meetingSetupUsecase.getSlots(eventTypeId);
    appointments.clear();

    slotEntity.slotsByDate.forEach((date, slots) {
      for (String slot in slots) {
        DateTime start = DateTime.parse(slot);
        appointments.add(Appointment(
          startTime: start.toLocal(),
          endTime: start.toLocal().add(Duration(minutes: minutes)),
          subject: "Available",
          isAllDay: false,
        ));
      }
    });

    isAvailable.value = true;
  }

  AppointmentDataSource getSlotSource() {
    return AppointmentDataSource(appointments);
  }


  Future<void> getBookingDetails(String bookingId) async {
    isLoading.value = true;
    bookingEntity = await _meetingSetupUsecase.getBookingDetails(bookingId);
    isLoading.value = false;
  }

  Future<void> getBookingGuidelines(String type) async {
    isGuidelinesLoading.value = true;
    final result = await _meetingSetupUsecase.getBookingGuidelines(type);
    guidelines = result.map((each) => each as String).toList();
    isGuidelinesLoading.value = false;
  }
}