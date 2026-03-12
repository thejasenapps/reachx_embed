import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';

abstract class WalletRepo {
  Future<Results> registerWallet(WalletEntity walletEntity);
  Future<Results> fetchBalance();
  Future<Results> fetchCouponTokens(String couponId);
  Future<Results> fetchUserName(String userId);
}