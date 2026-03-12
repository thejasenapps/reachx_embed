import 'package:flutter/material.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/presentation/commonWidgets/showRedSnackBar.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/walletViewModel.dart';

class RegisterWalletWidget extends StatelessWidget {
  final WalletViewModel walletViewModel;
  const RegisterWalletWidget({super.key, required this.walletViewModel});

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 100,
          children: [
            const SizedBox(height: 1,),
            const Text(
                "Get amazing discounts by registering you wallet with coupon code",
              style: TextStyle(
                fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Coupon Code:"),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 40,
                      minWidth: 100
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10)
                  ),
                  onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: walletViewModel.couponController,
                ),
              ],
            ),
            CustomElevatedButton(
                label: "Click to register your wallet",
                onTap: () async {
                  if(walletViewModel.couponController.text.isNotEmpty) {
                    Results results = await walletViewModel.registerWallet(context);
                    if(results is SuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registered"))
                      );
                      walletViewModel.fetchWalletDetails();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registration Unsuccessful"))
                      );
                    }
                  } else {
                    showRedSnackBar("Enter your coupon to register wallet", context);
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
