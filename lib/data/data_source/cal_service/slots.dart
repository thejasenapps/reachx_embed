import 'package:dio/dio.dart';
import 'package:reachx_embed/core/helper/apiService.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/models/slotModel.dart';

class Slots {

  final ApiClient _apiClient = ApiClient(Dio());

  // Fetches available slots within a specified time range for a given event type ID
  Future<Results> getAvailableSlots(String startDate, String endDate, int eventTypeId) async {
    try {
      var response = await _apiClient.request(
          requestType: RequestType.GET,
          path: '/v2/slots/available?startTime=$startDate&endTime=$endDate&eventTypeId=$eventTypeId',
          version: ''
      );

      if(response.statusCode == 200) {
        return Results.success(SlotModel.fromJson(response.data));
      } else {
        return Results.error("Error in showing slots");
      }
    } catch(e) {
      print(e);
      return Results.error(e);
    }
  }
}