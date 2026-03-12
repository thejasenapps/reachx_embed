import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';

abstract class BookingRepo {
  Future<bool> saveBooking(BookingEntity bookingEntity);
  Future<Results> scheduleBooking(BookingEntity bookingEntity);
  Future<UserEntity> getUserDetails();
  void getMeetingDetails();
  void saveTransactionDetails(double rate, String senderId, String receiverId, bool paidByWallet, double tokensSpent, String productId, String orderId);
  Future<bool> updateSessionDetails(String uniqueId, int slotCount);
  Future<bool> sendBookingNotification(BookingEntity bookingEntity);
  void updateWalletBalance(double rate, String expertId, String attendeeId);

  Future<int> getConversionRate(String typeId);
  Future<WalletEntity> getWalletBalance();

  void sendBookingEmail(Map<String, dynamic> data);
}