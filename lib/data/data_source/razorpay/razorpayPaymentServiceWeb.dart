import 'dart:async';
import 'dart:js_interop';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'dart:js_interop_unsafe';

// Note: Only use razorpay_flutter for mobile logic; it may conflict on web
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/getCurrencyCode.dart';




extension JSObjectParser on JSObject {
  String? getProperty(String key) {
    final property = (this as dynamic)[key];
    return property?.toString();
  }
}


class RazorpayPaymentService {
  final Dio _dio = Dio();
  final BuildContext context;

  static const razorpayKey = String.fromEnvironment('RAZORPAY_ID');


  Completer<Map<String, dynamic>>? _paymentCompleter;

  RazorpayPaymentService({required this.context});

  bool get _isRazorpayLoaded {
    final rp = globalContext['Razorpay'];
    return rp != null && rp.typeofEquals('function');
  }

  Future<void> _waitForRazorpay({int maxWaitMs = 20000}) async {
    const interval = 100;
    int waited = 0;
    while (!_isRazorpayLoaded) {
      if (waited >= maxWaitMs) {
        throw Exception('Razorpay SDK failed to load within ${maxWaitMs}ms');
      }
      await Future.delayed(const Duration(milliseconds: interval));
      waited += interval;
    }
  }

  Future<Map<String, dynamic>> startPayment({
    required int amount,
    required String currencySymbol,
    required String phoneNumber,
    required String email,
  }) async {
    _paymentCompleter = Completer<Map<String, dynamic>>();

    try {
      // await _waitForRazorpay();

      final orderId = await _createRazorpayOrderWeb(amount, currencySymbol);

      if (orderId == null) {
        return {"status": "error", "message": "Order creation failed"};
      }

      _openRazorpayCheckoutWeb(
          orderId: orderId,
          apiKey: razorpayKey,
          amount: amount.toDouble(),
          name: "ReachX",
          description: "Payment for session",
          currency: getCurrencyCodeFromSymbol(currencySymbol),
          email: email,
          phone: phoneNumber,
          onSuccess: (paymentId, signature) {
            _paymentCompleter?.complete({
              "status": "success",
              "paymentId": paymentId,
              "orderId": orderId,
              "signature": signature
            });
          },
          onFailure: (error) {
            _paymentCompleter?.complete({
              "status": "error",
              "message": error
            });
          });
    } catch (e, st) {
      Logger().e("💥 Web payment init failed", error: e, stackTrace: st);
      _paymentCompleter?.complete({"status": "error", "message": e.toString()});
    }
    return _paymentCompleter!.future;
  }

  void _openRazorpayCheckoutWeb({
    required String orderId,
    required String apiKey,
    required double amount,
    required String name,
    required String description,
    required String currency,
    required String email,
    required String phone,
    required Function(String paymentId, String signature) onSuccess,
    required Function(String error) onFailure,
  }) {
    final options = {
      'key': apiKey,
      'amount': amount.toInt(),
      'currency': currency,
      'name': name,
      'description': description,
      'order_id': orderId,
      'prefill': {
        'email': email,
        'contact': phone,
      },
      'handler': (JSObject response) {
        final paymentId = response.getProperty('razorpay_payment_id');
        final signature = response.getProperty('razorpay_signature');

        if (paymentId != null) {
          onSuccess(paymentId, signature ?? "");
        } else {
          onFailure("Payment ID missing in handler response");
        }
      }.toJS,
      'theme': {'color': '#3399cc'},
    }.jsify() as JSObject;

    final ctor = globalContext['Razorpay'] as JSFunction;
    final razorpay = ctor.callAsConstructor<JSObject>(options);

    // ✅ Listen for failure event with detailed reason
    razorpay.callMethod(
      'on'.toJS,
      'payment.failed'.toJS,
          (JSObject failureResponse) {
        final error = failureResponse['error'] as JSObject?;
        final code = error?.getProperty('code') ?? 'UNKNOWN';
        final description = error?.getProperty('description') ?? 'No description';
        final reason = error?.getProperty('reason') ?? 'No reason';
        final step = error?.getProperty('step') ?? 'No step';

        final message = 'Code: $code | Reason: $reason | Step: $step | Description: $description';
        Logger().e("🔴 Razorpay payment.failed → $message");
        onFailure(message);
      }.toJS,
    );

    razorpay.callMethod('open'.toJS);
  }

  Future<String?> _createRazorpayOrderWeb(int amount, String currencySymbol) async {
    try {
      final data = {
        "amount": amount.toString(),
        "currency": getCurrencyCodeFromSymbol(currencySymbol),
        "receipt": "rcpt_${DateTime.now().millisecondsSinceEpoch}",
      };

      final response = await _dio.post(
        "https://app.reachx.pro/api/razorpay/razorpay.php",
        data: FormData.fromMap(data),
      );

      return response.data["order_id"]?.toString();
    } catch (e) {
      Logger().e("Order creation failed: $e");
      return null;
    }
  }
}