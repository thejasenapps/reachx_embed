import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/data/models/feedModel.dart';


class SaveInFeedSupabase {

  final Dio _dio = Dio();
  final supabaseFeedApi = EnvConfig.supabaseFeedApi;
  String baseUrl = supabaseFeedUrl;


  Future<FeedModel?> insertFeedPost(FeedModel feedModel) async {
    const String tableName = 'insert_feed_post';

    try {
      String url = '$baseUrl$tableName';


      final response = await _dio.post(
        url,
        options: Options(
            headers: {
              'apikey': supabaseFeedApi,
              'Authorization': 'Bearer $supabaseFeedApi',
              'Content-Type': 'application/json',
            }
        ),
        data: feedModel.toJson(),
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
}