import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';

import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';


class UpdateInSupabase {

  final Dio _dio = Dio();

  static const apiKey = String.fromEnvironment('SUPABASE_API');
  String baseUrl = supabaseBaseUrl;

  Future<Results> updateWatchProgress(Map<String, dynamic> data) async {
    const String tableName = 'user_lesson_progress';

    try {

      final String url = '$baseUrl$tableName';
      final json = jsonEncode(data);

      final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'apikey': apiKey,
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
          ),
          data: json
      );


      if (response.statusCode == 200) {
        return Results.success('Successfully saved');
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Error: $e");
    }
  }



  Future<Results> subscribeToTool(String userId, String toolId) async {
    const String tableName = 'rpc/subscribe_to_tool';

    try {
      final String url = '$baseUrl$tableName';

      final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'apikey': apiKey,
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "p_user_id": userId,
            "p_tool_id": toolId
          }
      );

      if (response.statusCode == 200) {
        return Results.success("Successfully Updated");
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unsuccessful: $e");
    }
  }


  Future<Results> unSubscribeToTool(String userId, String toolId) async {
    const String tableName = 'rpc/unsubscribe_from_tool';

    try {
      final String url = '$baseUrl$tableName';

      final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'apikey': apiKey,
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            }
          ),
          data: {
            "p_user_id": userId,
            "p_tool_id": toolId
          }
      );


      if (response.statusCode == 200) {
        return Results.success("Successfully Updated");
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unsuccessful: $e");
    }
  }


  Future<Results> updateVideoInLesson(String lessonId, Map<String, dynamic> data) async {
    const String tableName = 'lessons';

    try {
      final String url = '$baseUrl$tableName?id=eq.$lessonId';

      final response = await _dio.patch(
          url,
          options: Options(
            headers: {
              'apikey': apiKey,
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "title": data["title"],
            "description": data["description"],
            "video_id": data["videoId"],
            "thumbnail_url": data["thumbnail"],
            "duration_seconds": data["duration"]
          }
      );


      if (response.statusCode == 200 || response.statusCode == 204) {
        return Results.success("Successfully Updated");
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unsuccessful: $e");
    }
  }
}