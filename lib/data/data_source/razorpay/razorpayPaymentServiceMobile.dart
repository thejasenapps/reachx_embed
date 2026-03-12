import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/getCurrencyCode.dart';

class RazorpayPaymentService {
  final Dio _dio = Dio();
  final Razorpay _razorpay = Razorpay();

  final razorpayKey = EnvConfig.razorpayId;
  final razorpaySecret = EnvConfig.razorpaySecret;

  final BuildContext context;
  Completer<Map<String, dynamic>>? _paymentCompleter;

  RazorpayPaymentService({required this.context}) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleWallet);
  }

  Future<Map<String, dynamic>> startPayment({
    required int amount,
    required String currencySymbol,
    required String phoneNumber,
    required String email,
  }) async {
    _paymentCompleter = Completer<Map<String, dynamic>>();
    try {
      final orderId = await _createOrder(amount, currencySymbol);
      if (orderId.isEmpty) {
        _paymentCompleter?.completeError("Order creation failed");
        return _paymentCompleter!.future;
      }

      _razorpay.open({
        "key": razorpayKey,
        "amount": amount,
        "order_id": orderId,
        "name": "ReachX",
        "description": "Payment for session",
        "prefill": {"contact": phoneNumber, "email": email},
        "timeout": 300,
        "retry": {'enabled': true, 'max_count': 4},
      });
    } catch (e) {
      _paymentCompleter?.completeError("Payment initialization failed: $e");
    }
    return _paymentCompleter!.future;
  }

  Future<String> _createOrder(int amount, String currencySymbol) async {
    try {
      final data = {
        "amount": amount.toString(),
        "currency": getCurrencyCodeFromSymbol(currencySymbol),
        "receipt": DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final response = await _dio.post(
        "https://app.reachx.pro/api/razorpay/razorpay.php",
        data: FormData.fromMap(data),
      );

      if (response.statusCode == 200 && response.data["order_id"] != null) {
        return response.data["order_id"];
      }
    } catch (e) {
      Logger().e("Order creation failed: $e");
    }
    return '';
  }

  void _handleSuccess(PaymentSuccessResponse res) {
    _paymentCompleter?.complete({
      "status": "success",
      "paymentId": res.paymentId,
      "orderId": res.orderId,
      "signature": res.signature
    });
  }

  void _handleError(PaymentFailureResponse res) {
    _paymentCompleter?.complete({
      "status": "error",
      "code": res.code,
      "message": res.message,
    });
  }

  void _handleWallet(ExternalWalletResponse res) {
    _paymentCompleter?.complete({
      "status": "external_wallet",
      "walletName": res.walletName,
    });
  }
}
