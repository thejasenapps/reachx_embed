import 'package:dio/dio.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

class BadgeSelectorApis {

  Future<Results> getSearchCode(String searchQuery) async {
    final dio = Dio(
        BaseOptions(followRedirects: true, maxRedirects: 5)
    );

    try {
      var response = await dio.post(
        "$badgeUrl/search/",
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
}
