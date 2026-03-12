import 'package:dio/dio.dart';
import 'package:reachx_embed/core/helper/apiService.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/expertRegistration/eventModel.dart';

class EventTypes {
  // API client for making HTTP requests
  final ApiClient _apiClient = ApiClient(Dio());

  // Creates a new event and returns the event ID if successful
  Future<Results> createEvent(EventModel eventModel) async {
    try {
      // Sends a POST request to create the event
      var response = await _apiClient.request(
        requestType: RequestType.POST,
        path: '/v2/event-types',
        version: '2024-06-14',
        data: eventModel.toJson(),
      );


      // Checks if the event creation was successful (status code 201)
      if (response.statusCode == 201) {
        final eventId = response.data["data"]["id"];
        return Results.success(eventId);
      } else {
        return Results.error("Event not registered");
      }
    } catch (e) {
      // Logs any errors and returns an error result
      print(e);
      return Results.error(e);
    }
  }


  Future<Results> updateEvent(EventModel eventModel, int eventId) async {
    try {
      // Sends a POST request to create the event
      var response = await _apiClient.request(
        requestType: RequestType.PATCH,
        path: '/v2/event-types/$eventId',
        version: '2024-06-14',
        data: eventModel.toJson(),
      );


      // Checks if the event creation was successful (status code 201)
      if (response.statusCode == 204 || response.statusCode == 200) {
        final eventId = response.data["data"]["id"];
        return Results.success(eventId);
      } else {
        return Results.error("Event not registered");
      }
    } catch (e) {
      // Logs any errors and returns an error result
      print(e);
      return Results.error(e);
    }
  }

  Future<Results> deleteEvent(int eventId) async {
    try{
      var response = await _apiClient.request(
          requestType: RequestType.DELETE,
          path: "/v2/event-types/$eventId",
          version: "2024-06-14"
      );

      if(response.statusCode == 200) {
        return Results.success(true);
      }
      return Results.error("Delete not completed");
    } catch(e) {
      return Results.error("Delete not completed");
    }
  }
}
