import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';
import 'package:reachx_embed/domain/wallet/walletRepo.dart';

class WalletUsecase {

  WalletRepo walletRepo = getIt();

  Future<Results> registerWallet(WalletEntity walletEntity) {
    return walletRepo.registerWallet(walletEntity);
  }

  Future<Results> fetchWalletDetails() {
    return walletRepo.fetchBalance();
  }

  Future<Results> fetchCouponTokens(String couponId) {
    return walletRepo.fetchCouponTokens(couponId);
  }

  Future<Results> getUserName(String userId) {
    return walletRepo.fetchUserName(userId);
  }
}