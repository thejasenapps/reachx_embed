import 'dart:async';
import 'dart:js_interop';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

// Note: Only use razorpay_flutter for mobile logic; it may conflict on web
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/getCurrencyCode.dart';

// --- JS Interop Definitions ---

@JS('Razorpay')
extension type Razorpay._(JSObject _) implements JSObject {
  external Razorpay(JSObject options);
  external void open();
  external void on(String event, JSFunction callback);
}

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

  Future<Map<String, dynamic>> startPayment({
    required int amount,
    required String currencySymbol,
    required String phoneNumber,
    required String email,
  }) async {
    _paymentCompleter = Completer<Map<String, dynamic>>();

    try {
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
          onFailure("Payment ID missing");
        }
      }.toJS,
      'theme': {'color': '#3399cc'},
    }.jsify() as JSObject;

    final razorpay = Razorpay(options);
    razorpay.open();
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