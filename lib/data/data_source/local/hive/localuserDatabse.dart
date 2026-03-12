import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/data/hiveModels/userModel.dart';

class LocalUserDatabase {

  static final LocalUserDatabase _instance = LocalUserDatabase._internal();
  factory LocalUserDatabase() => _instance;
  LocalUserDatabase._internal();

  static const String _boxName = 'users';
  static const String _feedCacheBox = "feed_cache_box";


  static Future<void> init() async {
    await Hive.initFlutter();

    final SharedPreferenceServices sharedPreferenceServices = SharedPreferenceServices();

    final isFirstRun = await sharedPreferenceServices.getValue("is_first_run");

    if (isFirstRun == null || isFirstRun) {
      await Hive.deleteBoxFromDisk(_boxName);
      await Hive.deleteBoxFromDisk(_feedCacheBox);

      sharedPreferenceServices.setValue("is_first_run", false);
    }

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<UserModel>(_boxName);
    }

    if(!Hive.isBoxOpen(_feedCacheBox)) {
      await Hive.openBox<int>(_feedCacheBox);
    }
  }

  Box<UserModel> get _userBox => Hive.box<UserModel>(_boxName);
  Box<int> get _feedBox => Hive.box<int>(_feedCacheBox);

  Future<Results> saveUser(UserModel userModel) async {
    try {
      await _userBox.put('passionate_user', userModel);
      return Results.success("User saved successfully");
    } catch (e, stack) {
      debugPrint("saveUser error: $e");
      debugPrintStack(stackTrace: stack);
      return Results.error("Save failed: $e");
    }
  }

  Future<Results> getUser() async {
    try {
      final user = _userBox.get('passionate_user');
      return Results.success(user);
    } catch (e, stack) {
      debugPrint("getUser error: $e");
      debugPrintStack(stackTrace: stack);
      return Results.error("Fetch failed: $e");
    }
  }


  Future<Results> deleteUser() async {
    try {
      await _userBox.delete('passionate_user');
      return Results.success("User deleted successfully");
    } catch (e, stack) {
      debugPrint("deleteUser error: $e");
      debugPrintStack(stackTrace: stack);
      return Results.error("Delete failed: $e");
    }
  }


  Future<void> saveLatestFeedTime(String badgeId, int timestamp) async {
    try {
      await _feedBox.put('feed_latest_$badgeId', timestamp);
    } catch (e, stack) {
      debugPrint("saveLatestFeedTime error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  int? getLatestFeedTime(String badgeId) {
    try {
      return _feedBox.get('feed_latest_$badgeId');
    } catch (e, stack) {
      debugPrint("getLatestFeedTime error: $e");
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  Future<void> clearFeedCache(String badgeId) async {
    try {
      await _feedBox.delete('feed_latest_$badgeId');
    } catch (e, stack) {
      debugPrint("clearFeedCache error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }
}