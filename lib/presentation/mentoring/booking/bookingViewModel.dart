import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customAnimatedAlertBox.dart';
import 'package:reachx_embed/presentation/commonWidgets/showRedSnackBar.dart';
import 'package:reachx_embed/data/data_source/razorpay/razorpayPaymentService.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/domain/booking/bookingUsecase.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/entities/walletEntity.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreen.dart';

class BookingViewModel extends GetxController{

  final BookingUseCase _bookingUseCase = BookingUseCase();

  double tokens = 0;
  int convRate = 0;
  double finalBalance = 0;
  double finalTokens = 0;
  int? paymentCharge;

  RxBool isConfirmed = false.obs;
  RxBool isLoading = false.obs;
  RxBool convLoading = false.obs;
  RxBool paidByWallet = false.obs;



  void paymentFlow(Map<String, dynamic> data, BuildContext context) async {
    try {
      final RazorpayPaymentService razorpayPaymentService = RazorpayPaymentService(context: context);
      isLoading.value = true;
      final UserEntity userEntity = await _bookingUseCase.getUserDetails();
      isLoading.value = false;

      if(paidByWallet.value == true) {
        data['rate'] = finalBalance.toInt();
      }

      if(data["rate"] > 0) {
        Map<String, dynamic> paymentResponse = await razorpayPaymentService.startPayment(
            amount: data["rate"],
            currencySymbol: data["currencySymbol"],
            phoneNumber: userEntity.phoneNo,
            email: userEntity.email
        );


        if(paymentResponse["status"] == "success") {

          data["paymentId"] = paymentResponse["paymentId"];
          data["orderId"] = paymentResponse["orderId"];

          confirmBooking(data, context, userEntity);
        } else {
          showRedSnackBar("Payment Failed, try again", context);
        }
      } else {
        confirmBooking(data, context, userEntity);
      }
    } catch(e) {
      print(e);
      showRedSnackBar("Error, Try later", context);
    }
  }


  // Confirms the booking by passing details to the use case
  void confirmBooking(Map<String, dynamic> bookingDetails, BuildContext context, UserEntity userEntity) async {


    var userId = await FirebaseAuthentication().getFirebaseUid();

    if(userId == bookingDetails["expertId"]) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You cannot book yourself"))
      );

      Navigator.of(context).pop("failed");
    } else {
      isConfirmed.value = false;
      isLoading.value = true;

      chargeInterest = await  GetFromFirestore().getPaymentCharge();
      Future<bool> result = _bookingUseCase.confirmBooking(bookingDetails, paidByWallet.value, finalTokens, userEntity);

      // Optionally log the result (success/failure) for debugging
      result.then((value) async {
        if(value) {
          isConfirmed.value = value;

          isLoading.value = false;

          await showDialog(
              context: context,
              builder: (context) {
                return const CustomAnimatedAlertBoxWidget(
                    label: "Booking Successful",
                    path: "lib/assets/lottie/true.json"
                );

              }
          );

          Navigator.of(context).pop("confirmed");
          Get.offAllNamed(
              HomeScreen.route,
              id: NavIds.home
          );
        } else {
          isLoading.value = false;

          Navigator.of(context).pop("failed");

        }
      }).catchError((error) {
        print("Error confirming booking: $error");
        Navigator.of(context).pop("failed");
      }).whenComplete(() {
        isLoading.value = false;
      });
    }
  }


  void getConversionRate(String currencySymbol) async {
    convLoading.value = true;
    String typeId = "inr";
    if(currencySymbol == "د.إ"){
     typeId = "aed";
    }
    if(currencySymbol == '\$'){
      typeId = "usd";
    }
    convRate = await _bookingUseCase.getConversionRate(typeId);

    WalletEntity walletEntity = await _bookingUseCase.getBalance();
    tokens = walletEntity.walletBalance;

    convLoading.value = false;
  }



  void walletDiscount(int rate) {
    if(convRate != 0) {
      if(tokens/convRate <= rate) {
        finalBalance = rate - tokens/convRate;
        finalTokens = tokens;
      } else {
        finalBalance = 0;
        finalTokens = rate.toDouble() * convRate;
      }
    }
  }

}
