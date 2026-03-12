import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/data/models/feedModel.dart';


class DeleteFromFeedSupabase {

  final Dio _dio = Dio();
  final supabaseFeedApi = EnvConfig.supabaseFeedApi;
  String baseUrl = supabaseFeedUrl;


  Future<FeedModel?> deleteFeedPost(String userId, String postId, String postType) async {
    const String tableName = 'delete_feed_post';

    try {
      String url = '$baseUrl$tableName';

      Map<String, dynamic> body = {
        'p_creator_id': userId,
        'p_post_id': postId,
        'p_post_type': postType
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