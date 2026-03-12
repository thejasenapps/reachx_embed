import 'package:dio/dio.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

/// Service for interacting with the ChromaDB API.
class ChromaDB {
  final Dio _dio = Dio();

  /// Adds a document to ChromaDB with a unique ID and provided text.
  Future<Results> addKeyword(String keywordId, String text) async {
    try {
      var response = await _dio.post(
        "$baseChromaUrl/add_keyword/",
        queryParameters: {
          "id": keywordId,
          "text": text
        },
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return Results.success(keywordId);
      }

      return Results.error(response.data);
    } catch(e) {
      print(e);
      return Results.error(e);
    }
  }

  /// Searches ChromaDB using the given query and retrieves the top result.
  Future<Results> getSearchCode(String searchQuery) async {
    final dio = Dio(
        BaseOptions(followRedirects: true, maxRedirects: 5)
    );

    try {
      var response = await dio.post(
        "$baseChromaUrl/search/",
        queryParameters: {
          "query_text": searchQuery,
          "top_k": 5
        },
      );
      return Results.success(response.data);
    } catch(e) {
      print(e);
      return Results.error(e);
    }
  }


  /// Searches ChromaDB using the given query and retrieves the top result.
  Future<Map<String, dynamic>> assignSearchCode(String topicDetail) async {
    final dio = Dio(
        BaseOptions(followRedirects: true, maxRedirects: 5)
    );

    try {
      var response = await dio.post(
        "$baseChromaUrl/search/",
        queryParameters: {
          "query_text": topicDetail,
          "top_k": 5
        },
      );
      return response.data;
    } catch(e) {
      print(e);
      return {};
    }
  }
}
