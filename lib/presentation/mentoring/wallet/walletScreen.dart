import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/findPlatform.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/booking/bookingViewModel.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/walletViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/widgets/balanceWidget.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/widgets/registerWalletWidget.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/widgets/transactionDetails.dart';


class WalletScreen extends StatefulWidget {
  static const route = "/walletScreen";
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletViewModel walletViewModel = getIt();

  BookingViewModel bookingViewModel = getIt();

  @override
  void initState() {
    walletViewModel.fetchWalletDetails();

    ever(bookingViewModel.isConfirmed, (bool isSaved) {
      if(mounted) {
        walletViewModel.fetchWalletDetails();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final containerHeight = findPlatform();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border.all(color: HexColor(containerBorderColor), width: 2),
            ),
            height: containerHeight,
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              leading: BackNavigationWidget(context: context),
              title: const Text(
                "Wallet",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                ),
              ),
            ),
          ),
        ),
      body: Obx(() {
        if(walletViewModel.isLoading.value) {
          return const Center(child: FlagWavingGif(),);
        } else {
          if(walletViewModel.walletEntity!.walletId.isNotEmpty) {
            return Column(
              children: [
                BalanceWidget(tokensLeft: tokensLeft,balance: balance, currencySymbol: walletViewModel.currencySymbol,),
                walletViewModel.transactionsEntity.transactions.isNotEmpty
                  ? TransactionDetails(
                  transactions: walletViewModel.transactionsEntity,
                  currencySymbol: walletViewModel.currencySymbol,
                  walletViewModel: walletViewModel,
                )
                  : const Center(
                    child: Text("No transactions")
                ),
                const SizedBox(height: 90,)
              ],
            );
          } else {
            return RegisterWalletWidget(walletViewModel: walletViewModel);
          }
        }
      })
    );
  }
}
