import 'package:get/get.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';

String status = "offline";
bool expertReg = false;

String checkpoint = "homeScreen";

RxBool signal = false.obs;

String fcmToken = '';

int chargeInterest = 0;

RxBool isExpert = false.obs;

Set<List<String>> topicList = {};

double tokensLeft = 0;
double balance = 0;

double wallet = 2000;

String officialPhone = '';

RecaptchaClient? client;

String paymentIdSyntax = "RXRP-";

bool subscriptionStatus = true;



