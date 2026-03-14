import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';

import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/data/models/feedModel.dart';


class UpdateInFeedSupabase {

  final Dio _dio = Dio();
  static const supabaseFeedApi = String.fromEnvironment('SUPABSE_FEED_API');
  String baseUrl = supabaseFeedUrl;


  Future<FeedModel?> likeFeedPost(String userId, String feedId) async {
    const String tableName = 'like_feed_post';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_user_id': userId,
        'p_feed_id': feedId,
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
        return FeedModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }


  Future<FeedModel?> unlikeFeedPost(String userId, String feedId) async {
    const String tableName = 'unlike_feed_post';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_user_id': userId,
        'p_feed_id': feedId,
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
        return FeedModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }


  Future<FeedModel?> updateFeedPost(Map<String, dynamic> data) async {
    const String tableName = 'update_feed_post';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_post_id': data["postId"],
        'p_creator_id': data["userId"],
        'p_post_type': data["postType"],
        'p_new_post_data': data["postData"],
        'p_new_post_type': data["newPostType"]
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
        return FeedModel.fromJson(response.data);
      } else {
        throw Exception(
            'Status code: ${response.statusCode}, body: ${response.data}');
      }
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }
}