import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/data/hiveModels/userModel.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/susbcriptionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';

RxBool isGlobalLoading = false.obs;
RxBool isSubscriptionLoading = false.obs;
RxString globalUserId = ''.obs;
RxInt globalStreakCount = (-1).obs;
Rx<DateTime> globalLastUpdatedTime = DateTime.now().obs;
RxBool toDiscover = false.obs;
RxBool toMentor = false.obs;
RxBool toExpertDetail = false.obs;
RxBool fromHome = false.obs;
RxInt noOfTries = (-1).obs;
RxBool activatePopup = true.obs;

String inviteeExpertId = '';
String inviteetopicId = '';

final globalExpertEntity = ExpertEntity(
  uniqueId: '',
  name: '',
  minutes: 60,
  topics: [],
  intro: '',
  location: "unknown",
  experience: 0,
  languages: [],
  achievements: [],
  imageFile: ''
).obs;

var globalTopics = <TopicEntity>[].obs;
var globalSessions = <SessionEntity>[].obs;
var globalPassions = <TopicEntity>[].obs;
var globalSubscriptionEntity = <SubscriptionEntity>[].obs;
var globalSubscriptionStatus = SubscriptionStatus.beginner.obs;
final globalUri = Rx<Uri>(Uri());
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
RxBool globalLoggedIn = false.obs;
Rxn<UserModel> userModel = Rxn<UserModel>();

double? maxGlobalHeight;
RxString globalInstitutionId = ''.obs;
