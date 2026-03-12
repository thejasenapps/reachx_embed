import 'package:dio/dio.dart';
import 'package:reachx_embed/core/helper/apiService.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/models/scheduleModel.dart';

class Schedules {
  // API client for making HTTP requests
  final ApiClient _apiClient = ApiClient(Dio());

  // Creates a new schedule and returns the schedule ID if successful
  Future<Results> createSchedule({required ScheduleModel scheduleModel}) async {
    try {
      // Sends a POST request to create a new schedule
      final response = await _apiClient.request(
        requestType: RequestType.POST,
        path: '/v2/schedules',
        version: '2024-06-11',
        data: scheduleModel.toJson(),
      );

      // Checks if the schedule creation was successful (status code 201)
      if (response.statusCode == 201) {
        final scheduleId = response.data["data"]["id"];
        return Results.success(scheduleId);
      } else {
        return Results.error("Error creating schedule");
      }
    } catch (e) {
      // Logs any errors and returns an error result
      print(e);
      return Results.error(e);
    }
  }


  Future<Results> updateSchedule({required ScheduleModel scheduleModel, required String scheduleId}) async {
    try {
      // Sends a POST request to create a new schedule
      final response = await _apiClient.request(
        requestType: RequestType.PATCH,
        path: '/v2/schedules/$scheduleId',
        version: '2024-06-11',
        data: scheduleModel.toJson(),
      );

      // Checks if the schedule creation was successful (status code 201)
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Results.success(true);
      } else {
        return Results.error("Error creating schedule");
      }
    } catch (e) {
      // Logs any errors and returns an error result
      print(e);
      return Results.error(e);
    }
  }


  Future<Results> deleteSchedule({required int scheduleId}) async {
    try {
      // Sends a POST request to create a new schedule
      final response = await _apiClient.request(
        requestType: RequestType.DELETE,
        path: '/v2/schedules/$scheduleId',
        version: '2024-06-11',
      );

      // Checks if the schedule creation was successful (status code 201)
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Results.success(true);
      } else {
        return Results.error("Error deleting schedule");
      }
    } catch (e) {
      // Logs any errors and returns an error result
      print(e);
      return Results.error(e);
    }
  }
}
