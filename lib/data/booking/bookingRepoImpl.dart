import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/remote/emailNotificationService.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/pushNotifications.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/whatsappNotifications.dart';
import 'package:reachx_embed/data/models/bookingModel.dart';
import 'package:reachx_embed/data/data_source/cal_service/booking.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/models/transactionModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/data/models/walletModel.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/booking/bookingRepo.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';
import 'package:uuid/uuid.dart';

class BookingRepoImpl implements BookingRepo {
  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final EmailNotificationService _emailNotificationService = EmailNotificationService();

  final Booking _booking = Booking();
  final PushNotifications _notifications = PushNotifications();
  final WhatsappNotifications _whatsappNotifications = WhatsappNotifications();
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  var storageModel;
  int bookingId = 0;
  String bookingUniqueId = '';
  String meetingUrl = '';

  @override
  Future<UserModel> getUserDetails() {
    return _getFromFirestore.getUserProfileDetails();
  }

  @override
  Future<bool> saveBooking(BookingEntity bookingEntity) async {
    var uuid = const Uuid().v4();

    if (bookingEntity.session!.toLowerCase() == "online" &&
        bookingEntity.sessionType == "oneToOne") {
      storageModel = OnlineOneToOneStorageModel(
          start: bookingEntity.start,
          eventId: bookingEntity.eventId,
          topicId: bookingEntity.topicId,
          attendee: bookingEntity.attendee,
          eventName: bookingEntity.eventName,
          selectedDate: bookingEntity.selectedDate,
          description: bookingEntity.description,
          rate: bookingEntity.rate,
          bookingId: bookingId,
          bookingUniqueId: bookingUniqueId,
          attendeeId: bookingEntity.attendeeId,
          lengthInMinutes: bookingEntity.lengthInMinutes,
          meetingUrl: meetingUrl,
          meetingStatus: bookingEntity.meetingStatus,
          expertName: bookingEntity.expertName,
          expertId: bookingEntity.expertId,
          rescheduleId: bookingEntity.rescheduleId,
          rescheduleStatus: bookingEntity.rescheduleStatus,
          session: bookingEntity.session,
          sessionType: bookingEntity.sessionType,
          sessionId: bookingEntity.sessionId,
          notificationSent: bookingEntity.notificationSent

      );
    } else if (bookingEntity.session!.toLowerCase() == "online" &&
        bookingEntity.sessionType == "group") {
      storageModel = OnlineGroupStorageModel(
          start: bookingEntity.start,
          topicId: bookingEntity.topicId,
          eventName: bookingEntity.eventName,
          selectedDate: bookingEntity.selectedDate,
          description: bookingEntity.description,
          rate: bookingEntity.rate,
          lengthInMinutes: bookingEntity.lengthInMinutes,
          meetingUrl: bookingEntity.meetingUrl,
          meetingStatus: bookingEntity.meetingStatus,
          expertName: bookingEntity.expertName,
          expertId: bookingEntity.expertId,
          rescheduleId: bookingEntity.rescheduleId,
          rescheduleStatus: bookingEntity.rescheduleStatus,
          session: bookingEntity.session,
          sessionType: bookingEntity.sessionType,
          groupSlots: bookingEntity.groupSlots,
          attendee: bookingEntity.attendee,
          attendeeId: bookingEntity.attendeeId,
          sessionId: bookingEntity.sessionId,
          bookingUniqueId: uuid,
          notificationSent: bookingEntity.notificationSent

      );
    } else if (bookingEntity.session!.toLowerCase() == "onsite" &&
        bookingEntity.sessionType == "oneToOne") {
      storageModel = OfflineOneToOneStorageModel(
          start: bookingEntity.start,
          eventName: bookingEntity.eventName,
          selectedDate: bookingEntity.selectedDate,
          description: bookingEntity.description,
          rate: bookingEntity.rate,
          bookingId: bookingId,
          bookingUniqueId: bookingUniqueId,
          lengthInMinutes: bookingEntity.lengthInMinutes,
          meetingStatus: bookingEntity.meetingStatus,
          expertName: bookingEntity.expertName,
          expertId: bookingEntity.expertId,
          rescheduleId: bookingEntity.rescheduleId,
          rescheduleStatus: bookingEntity.rescheduleStatus,
          session: bookingEntity.session,
          sessionType: bookingEntity.sessionType,
          eventId: bookingEntity.eventId,
          topicId: bookingEntity.topicId,
          attendee: bookingEntity.attendee,
          attendeeId: bookingEntity.attendeeId,
          location: bookingEntity.location,
          sessionId: bookingEntity.sessionId,
          notificationSent: bookingEntity.notificationSent

      );
    } else if (bookingEntity.session!.toLowerCase() == "onsite" &&
        bookingEntity.sessionType == "group") {
      storageModel = OfflineGroupStorageModel(
          start: bookingEntity.start,
          topicId: bookingEntity.topicId,
          eventName: bookingEntity.eventName,
          selectedDate: bookingEntity.selectedDate,
          description: bookingEntity.description,
          rate: bookingEntity.rate,
          lengthInMinutes: bookingEntity.lengthInMinutes,
          meetingStatus: bookingEntity.meetingStatus,
          expertName: bookingEntity.expertName,
          expertId: bookingEntity.expertId,
          rescheduleId: bookingEntity.rescheduleId,
          rescheduleStatus: bookingEntity.rescheduleStatus,
          session: bookingEntity.session,
          sessionType: bookingEntity.sessionType,
          attendeeId: bookingEntity.attendeeId,
          location: bookingEntity.location,
          groupSlots: bookingEntity.groupSlots,
          attendee: bookingEntity.attendee,
          sessionId: bookingEntity.sessionId,
          bookingUniqueId: uuid,
          notificationSent: bookingEntity.notificationSent

      );
    }

    bool result = await _saveInFirestore.saveBookingDetails(
        uuid, bookingModel: storageModel);

    return result;
  }

  @override
  Future<Results> scheduleBooking(BookingEntity bookingEntity) async {
    BookingScheduleModel bookingScheduleModel = BookingScheduleModel(
      start: bookingEntity.start,
      eventId: bookingEntity.eventId,
      attendee: AttendeeModel(
        name: bookingEntity.attendee.name,
        timeZone: bookingEntity.attendee.timeZone,
        email: bookingEntity.attendee.email ?? '',
        language: bookingEntity.attendee.language ?? '',
        phoneNumber: bookingEntity.attendee.phoneNumber ?? '',
      ),
      lengthInMinutes: bookingEntity.lengthInMinutes ?? 60,
      guests: bookingEntity.guests ?? [],
      location: bookingEntity.location ?? '',
      meetingUrl: meetingUrl,
      metadata: bookingEntity.metadata != null
          ? MetadataModel(key: bookingEntity.metadata!.key)
          : null,
      bookingFieldResponses: bookingEntity.bookingFieldResponses != null
          ? BookingFieldResponsesModel(
          customField: bookingEntity.bookingFieldResponses!.customField)
          : null,
    );


    Results results = await _booking.createBooking(bookingScheduleModel);

    if (results is SuccessState) {
      bookingId = results.value[0];
      bookingUniqueId = results.value[1];
      meetingUrl = results.value[2];
    }

    return results;
  }


  @override
  void saveTransactionDetails(double rate, String senderId, String receiverId, bool paidByWallet, double tokensSpent, String productId, String orderId) async {

    String invoiceId = '';

    if(orderId.isNotEmpty) {
      final serialNo = await _getFromFirestore.getSerialNumber();
      invoiceId = "$paymentIdSyntax${senderId.substring(0,2)}${senderId.substring(0,2)}-$serialNo";
    }


    double reachExCharge = (rate * chargeInterest) / 100;
    double expertPayment = rate - reachExCharge;

    TransactionModel transactionModel = TransactionModel(
        id: const Uuid().v4(),
        amount: expertPayment,
        timestamp: DateTime.now(),
        type: "payment",
        transactionIds: [senderId, receiverId],
        bookingId: bookingId.toString(),
        reachExCharge: reachExCharge,
        paidByWallet: paidByWallet,
        tokensSpent: tokensSpent,
        productId: productId,
        orderId: orderId,
        invoiceId: invoiceId
    );

    bool response = await _saveInFirestore.saveTransactionDetails(transactionModel: transactionModel);

    if(response) {
      _updateInFirestore.updatePaymentNo();
    }
  }

  @override
  Future<bool> updateSessionDetails(String uniqueId, int groupSlot) {
    return _updateInFirestore.updateCountInSession(uniqueId, groupSlot);
  }

  @override
  void getMeetingDetails() {
    meetingUrl = "not-yet";
  }

  @override
  Future<bool> sendBookingNotification(BookingEntity bookingEntity) async {
    List<String> senderTokes = [];
    UserModel? userModel = await _getFromFirestore.getUserDetails(bookingEntity.expertId!);
    senderTokes.add(bookingEntity.expertId!);

    String title = "New Booking";
    String content = "A new booking for ${bookingEntity.eventName}";
    Map<String, dynamic> data = {
      "id": bookingEntity.expertId,
    };

    _notifications.sendPushNotifications(
        [userModel.fcmToken!], title, content, data);


    final time = formattedTime(bookingEntity.start);

    _whatsappNotifications.sendBookingAlertToPassionate({
      "expertNo": userModel.phoneNo,
      "topic": bookingEntity.eventName,
      "time": time,
      "mode": bookingEntity.session!.toLowerCase() == "online"
          ? "Online": "Offline"
    });

    return true;
  }

  @override
  void updateWalletBalance(double tokens, String expertId, String attendeeId) async {
    checkBalanceAndSubmit(tokens, attendeeId, false);
  }

  @override
  Future<int> getConversionRate(String typeId) async {
    Map<String, dynamic> data =  await _getFromFirestore.getConversionRate(typeId);

    if(data[typeId] != null) {
      return data[typeId];
    }
    return 0;
  }

  @override
  Future<WalletEntity> getWalletBalance() async {
    String? userId = await FirebaseAuthentication().getFirebaseUid();

    if(userId != null) {
      return _getFromFirestore.getBalance(userId);
    }
    return WalletEntity(walletBalance: 0, walletId: '', currencySymbol: '');
  }

  @override
  void sendBookingEmail(Map<String, dynamic> data) {
    _emailNotificationService.sendEmail(data);
  }
  
  
  void checkBalanceAndSubmit(double tokens, String userId, bool sender) async {
    WalletModel walletModel = await _getFromFirestore.getBalance(userId);
    late double balance;
    if(sender) {
      balance =  walletModel.walletBalance + tokens;
    } else {
      balance = walletModel.walletBalance - tokens;
    }
    
    Map<String, dynamic> data = {
      "walletBalance": balance
    };
    
    _updateInFirestore.updateBalance(data, userId);
  }



  String formattedTime(String utcTime) {
    final response = _dateAndTimeConvertors.fromUTC(utcTime);

    final formattedTime = _dateAndTimeConvertors.formatTimeOfDay(response["time"]);

    return '$formattedTime ${response["date"]}';
  }
}
