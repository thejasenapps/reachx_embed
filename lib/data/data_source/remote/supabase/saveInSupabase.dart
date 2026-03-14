import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';

import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/models/roadMapModel.dart';
import 'package:reachx_embed/data/models/toolsModel.dart';

class SaveInSupabase {

  final Dio _dio = Dio();

  static const apiKey = String.fromEnvironment('SUPABASE_API');
  String baseUrl = supabaseBaseUrl;


  Future<Results> saveLearningContent(List<RoadMapModel> roadMapsModel) async {
    const String tableName = 'lessons';

    try {
      final String url = '$baseUrl$tableName';
      final json = jsonEncode(roadMapsModel);

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          }
        ),
        data: json
      );


      if (response.statusCode == 200  || response.statusCode == 201) {
        return Results.success("Successfully saved");
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unknown error: $e");
    }
  }

  Future<Results> saveTool(ToolModel toolModel) async {
    const String tableName = 'user_custom_tools';

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
          data: toolModel.toJson()
      );


      if (response.statusCode == 200  || response.statusCode == 201) {

        return Results.success("Successful");
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unknown error: $e");
    }
  }

}