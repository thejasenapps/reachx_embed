import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/booking/bookingRepo.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';

class BookingUseCase {

  BookingRepo bookingRepo = getIt();

  Future<bool> confirmBooking(Map<String, dynamic> bookingDetails, bool paidByWallet, double tokensSpent, UserEntity userEntity) async {
    final String? userId = await FirebaseAuthentication().getFirebaseUid();
    final DateAndTimeConvertors dateAndTimeConvertors = DateAndTimeConvertors();

    bool saveResponse = false;
    String? start;

    if(bookingDetails["sessionType"] != "group") {
      start = dateAndTimeConvertors.toUTC(bookingDetails["selectedDate"].toString(), bookingDetails["selectedTime"][0]) ;
    } else {
      DateTime parsedDate = DateTime.parse(bookingDetails["dateTime"]);
      start = parsedDate.toUtc().toIso8601String();
    }

    // Create a booking entity with provided booking details
    BookingEntity bookingEntity = BookingEntity(
        start: start,
        topicId: bookingDetails["topicId"],
        eventId: bookingDetails["eventId"],
        expertName: bookingDetails["expertName"] ?? "test",
        attendeeId: userId ?? '',
        attendee: Attendee(
          name: userEntity.name,
          timeZone: "Asia/Calcutta",
          email: userEntity.email,
          phoneNumber: userEntity.phoneNo,
        ),
        lengthInMinutes: bookingDetails["minutes"],
        guests: bookingDetails["guests"] ?? [],
        meetingUrl: bookingDetails["meetingUrl"] ?? '',
        location: bookingDetails["location"] ?? '',
        eventName: bookingDetails["name"],
        description: bookingDetails["description"] ?? '',
        selectedDate: bookingDetails["selectedDate"].toString(),
        rate: bookingDetails["rate"] ?? 0,
        expertId: bookingDetails["expertId"] ?? '',
        sessionType: bookingDetails["sessionType"],
        session: bookingDetails["session"],
        groupHours: bookingDetails["selectedHours"],
        groupSlots: bookingDetails["slotsBooked"],
        sessionId: bookingDetails["sessionId"]
    );

    if(bookingDetails["sessionType"] != "group") {
      Results scheduleResponse = await bookingRepo.scheduleBooking(bookingEntity);

      if (scheduleResponse is SuccessState) {
        saveResponse = await bookingRepo.saveBooking(bookingEntity);
      }
    } else {
      saveResponse = await bookingRepo.saveBooking(bookingEntity);

      if(saveResponse) {
        int slotLeft = bookingDetails["groupSlotLeft"] - bookingDetails["slotsBooked"];
        bookingRepo.updateSessionDetails(bookingDetails["sessionId"], slotLeft);
      }
    }

    if(saveResponse) {
      bookingRepo.saveTransactionDetails(
          bookingEntity.rate!.toDouble(),
          bookingEntity.expertId!,
          bookingEntity.attendeeId!,
          paidByWallet,
          tokensSpent,
          bookingDetails["paymentId"] ?? '',
          bookingDetails["orderId"] ?? ''
      );
      bookingRepo.updateWalletBalance(tokensSpent, bookingEntity.expertId!, bookingEntity.attendeeId!);
      bookingRepo.sendBookingNotification(bookingEntity);

      final data = {
        "event": "new-booking",
        "sender": bookingEntity.attendee.name,
        "receiver": bookingEntity.expertName,
        "date": bookingEntity.start
      };

      bookingRepo.sendBookingEmail(data);
    }
    return saveResponse;
  }


  Future<int> getConversionRate(String typeId) {
    return bookingRepo.getConversionRate(typeId);
  }

  Future<WalletEntity> getBalance() {
    return bookingRepo.getWalletBalance();
  }

  Future<UserEntity> getUserDetails() {
    return bookingRepo.getUserDetails();
  }
}
