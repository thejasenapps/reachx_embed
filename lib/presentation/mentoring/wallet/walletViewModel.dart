import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/entities/transactionEntity.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';
import 'package:reachx_embed/domain/wallet/walletUsecase.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';

class WalletViewModel {

  final firebaseAuthentication = FirebaseAuthentication();
  final walletUsecase = WalletUsecase();
  final ProfileViewModel profileViewModel = getIt();

  String currencySymbol = '';
  String? userId;

  RxBool isLoading = false.obs;

  TextEditingController couponController = TextEditingController();

  late TransactionsEntity transactionsEntity;
  WalletEntity? walletEntity;

  Future<Results> registerWallet(BuildContext context) async {
    userId = await firebaseAuthentication.getFirebaseUid();

    if(userId != null) {

      Results results = await walletUsecase.fetchCouponTokens(couponController.text);

      if(results is SuccessState) {
          final  balance = (results.value as num).toDouble();
          WalletEntity walletEntity = WalletEntity(
              walletBalance: balance,
              walletId: userId!,
              currencySymbol: "₹"
          );
          return walletUsecase.registerWallet(walletEntity);
      }
    }

    return Results.error('');
  }

  Future<void> fetchWalletDetails() async {
    isLoading.value = true;
    userId = await firebaseAuthentication.getFirebaseUid();
    balance = 0;

    Results results = await walletUsecase.fetchWalletDetails();

    if(results is SuccessState) {
      Map<String, dynamic> data = results.value;
      transactionsEntity = data["transactions"] as TransactionsEntity;
      walletEntity = data["walletEntity"] as WalletEntity;

      transactionsEntity.transactions.sort((a,b) {
        return b.timestamp.compareTo(a.timestamp);
      });

      for( final each in transactionsEntity.transactions) {
        if(userId != null) {
          final payeeId = each.transactionIds.firstWhere((id) => id != userId);

          Results results = await walletUsecase.getUserName(payeeId);

          if(results is SuccessState) {
            each.payeeName = results.value;
          } else if(results is ErrorState ){
            each.payeeName = results.msg;
          }
        }

        if( each.transactionIds.isNotEmpty && each.transactionIds[0] == userId) {
          balance += each.amount;
        }
      }

      tokensLeft = (walletEntity!.walletBalance as num).toDouble();
      currencySymbol = walletEntity!.currencySymbol;
    }

    isLoading.value = false;
  }
}