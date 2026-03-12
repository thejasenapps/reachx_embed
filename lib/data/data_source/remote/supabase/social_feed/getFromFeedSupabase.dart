import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/data/models/feedModel.dart';


class GetFromFeedSupabase {

  final Dio _dio = Dio();
  final supabaseFeedApi = EnvConfig.supabaseFeedApi;
  String baseUrl = supabaseFeedUrl;


  Future<FeedModels> getFeedByBadge(Map<String, dynamic> data) async {
    const String tableName = 'get_feed_by_badge';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_badge_id': data["badgeId"],
        'p_current_user_id': data["userId"],
        if(data["limit"] != null) 'p_limit': data["limit"],
        if(data["offset"] != null) 'p_offset': data["offset"]
      };

      final response = await _dio.post(
        url,
        options: Options(
            headers: {
              'apikey': supabaseFeedApi,
              'Authorization': 'Bearer $supabaseFeedApi',
              'Content-Type': 'application/json',
            }
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return FeedModels.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return FeedModels.empty();
    }
  }


  Future<FeedModels> getFeedByBadgeBefore(Map<String, dynamic> data) async {
    const String tableName = 'get_feed_by_badge_before';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_badge_id': data["badgeId"],
        'p_current_user_id': data["userId"],
        'p_before': data["timestamp"],
        if(data["limit"] != null) 'p_limit': data["limit"],
        if(data["offset"] != null) 'p_offset': data["offset"]
      };

      final response = await _dio.post(
        url,
        options: Options(
            headers: {
              'apikey': supabaseFeedApi,
              'Authorization': 'Bearer $supabaseFeedApi',
              'Content-Type': 'application/json',
            }
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return FeedModels.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return FeedModels.empty();
    }
  }


  Future<FeedModels> getFeedByBadgeCreators(Map<String, dynamic> data) async {
    const String tableName = 'get_feed_by_badge_creators';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_badge_id': data["badgeId"],
        'p_current_user_id': data["userId"],
        'p_creator_ids': data["creatorsIds"],
        if(data["limit"] != null) 'p_limit': data["limit"],
        if(data["offset"] != null) 'p_offset': data["offset"]
      };

      final response = await _dio.post(
        url,
        options: Options(
            headers: {
              'apikey': supabaseFeedApi,
              'Authorization': 'Bearer $supabaseFeedApi',
              'Content-Type': 'application/json',
            }
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return FeedModels.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return FeedModels.empty();
    }
  }

  Future<FeedModels> getFeedByBadgeCreatorsBefore(Map<String, dynamic> data) async {
    const String tableName = 'get_feed_by_badge_creators';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_badge_id': data["badgeId"],
        'p_current_user_id': data["userId"],
        'p_creator_ids': data["creatorsIds"],
        'p_before': data["timestamp"],
        if(data["limit"] != null) 'p_limit': data["limit"],
        if(data["offset"] != null) 'p_offset': data["offset"]
      };

      final response = await _dio.post(
        url,
        options: Options(
            headers: {
              'apikey': supabaseFeedApi,
              'Authorization': 'Bearer $supabaseFeedApi',
              'Content-Type': 'application/json',
            }
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return FeedModels.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return FeedModels.empty();
    }
  }


}