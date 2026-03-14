import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';

import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

class ApiClient extends ChangeNotifier {
  final Dio _dio;

  ApiClient(this._dio);

  static const _apiKey = String.fromEnvironment('API_KEY');

  /// Handles API requests (GET, POST)
  Future<Response> request({
    required RequestType requestType,
    required String path,
    required String version,
    dynamic data = Nothing
  }) async {
    switch(requestType) {
      case RequestType.GET:
        return _dio.get(
            '$baseApiUrl$path',
            options: Options(headers: {
              'Authorization': 'Bearer $_apiKey',
              'cal-api-version': version
            })
        );

      case RequestType.POST:
        return _dio.post(
            '$baseApiUrl$path',
            options: Options(headers: {
              'Authorization': 'Bearer $_apiKey',
              'cal-api-version': version,
              'Content-type': 'application/json',
            }),
            data: data
        );

      case RequestType.PATCH:
        return _dio.patch(
            '$baseApiUrl$path',
            options: Options(headers: {
              'Authorization': 'Bearer $_apiKey',
              'cal-api-version': version,
              'Content-type': 'application/json',
            }),
            data: data
        );

        case RequestType.DELETE:
          return _dio.delete(
              '$baseApiUrl$path',
              options: Options(headers: {
                'Authorization': 'Bearer $_apiKey',
                'cal-api-version': version,
              }),
          );

      }
  }
}
