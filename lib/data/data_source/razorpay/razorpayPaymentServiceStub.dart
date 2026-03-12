import 'package:flutter/material.dart';

class RazorpayPaymentService {
  RazorpayPaymentService({required BuildContext context});

  Future<Map<String, dynamic>> startPayment({
    required int amount,
    required String currencySymbol,
    required String phoneNumber,
    required String email,
  }) async {
    throw UnsupportedError("Razorpay not supported on this platform.");
  }
}
