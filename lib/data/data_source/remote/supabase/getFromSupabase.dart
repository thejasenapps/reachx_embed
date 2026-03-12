import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/models/badgeModel.dart';
import 'package:reachx_embed/data/models/eventModel.dart';
import 'package:reachx_embed/data/models/toolsModel.dart';


class GetFromSupabase {

  final Dio _dio = Dio();
  final supabaseApi = EnvConfig.supabaseApi;
  String baseUrl = supabaseBaseUrl;




  Future<EventsModel> getEvents() async {
    const String tableName = 'events';

    try {
      final String url = '$baseUrl$tableName?order=event_datetime.asc';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'apikey': supabaseApi,
            'Authorization': 'Bearer $supabaseApi',
            'Content-Type': 'application/json',
          },
        )
      );

      final data = response.data;

      if (response.statusCode == 200) {
        return EventsModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return EventsModel(events: []);
    }
  }


  Future<ToolsModel> getTools(String badgeId, String userId) async {
    const String tableName = 'rpc/get_tools_by_badge_and_user';

    try {
      final String url = '$baseUrl$tableName';

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'apikey': supabaseApi,
            'Authorization': 'Bearer $supabaseApi',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "input_badge_id": badgeId,
          "input_user_id": userId
        }
      );

      final data = response.data;

      if (response.statusCode == 200 && data != null ) {
        return ToolsModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return ToolsModel(tools: []);
    }
  }

  Future<ToolsModel> getUserTools(String userId) async {
    const String tableName = 'rpc/get_user_created_tools';

    try {
      final String url = '$baseUrl$tableName';

      final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'apikey': supabaseApi,
              'Authorization': 'Bearer $supabaseApi',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "user_uuid": userId
          }
      );

      final data = response.data;

      if (response.statusCode == 200 && data.isNotEmpty) {
        return ToolsModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return ToolsModel(tools: []);
    }
  }

  //
  // Future<BadgeModelList> getBadges(String search) async {
  //   String tableName = '';
  //
  //   if(search.isNotEmpty) {
  //     tableName = 'badges?select=*&keyword=eq.$search';
  //   } else {
  //     tableName = 'badges?select=*';
  //   }
  //
  //   try {
  //     final String url = '$baseUrl$tableName';
  //
  //     final response = await _dio.get(
  //         url,
  //         options: Options(
  //           headers: {
  //             'apikey': supabaseApi,
  //             'Authorization': 'Bearer $supabaseApi',
  //             'Content-Type': 'application/json',
  //           },
  //         )
  //     );
  //
  //     final data = response.data;
  //
  //     if (response.statusCode == 200) {
  //       return BadgeModelList.fromJson(data);
  //     } else {
  //       throw Exception(
  //           'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
  //     }
  //
  //   } catch(e) {
  //     debugPrint(e.toString());
  //     return BadgeModelList(badges: []);
  //   }
  // }

  Future<BadgeModelList> getBadges(List<String> keywords) async {
    String tableName = 'rpc/get_badge_by_keyword';

    try {
      final String url = '$baseUrl$tableName';

      final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'apikey': supabaseApi,
              'Authorization': 'Bearer $supabaseApi',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "input_keywords": keywords
          }
      );

      final data = response.data;

      if (response.statusCode == 200) {
        return BadgeModelList.fromJson(data);
      } else {
        throw Exception(
            'Failed to load lessons. Status code: ${response.statusCode}, body: ${response.data}');
      }

    } catch(e) {
      debugPrint(e.toString());
      return BadgeModelList(badges: []);
    }
  }

}