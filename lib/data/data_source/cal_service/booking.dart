import 'package:dio/dio.dart';
import 'package:reachx_embed/core/helper/apiService.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/models/bookingModel.dart';

class Booking {
  // API client for handling HTTP requests
  final ApiClient _apiClient = ApiClient(Dio());

  // Creates a new booking and returns the event ID if successful
  Future<Results> createBooking(BookingScheduleModel bookingModel) async {

    final testBooking = bookingModel.toJson();

    try {
      var response = await _apiClient.request(
        requestType: RequestType.POST,
        path: '/v2/bookings',
        version: '2024-08-13',
        data: bookingModel.toJson(),
      );



      if (response.statusCode == 201) {
        final bookingId = response.data["data"]["id"];
        final bookingUniqueId = response.data["data"]["uid"];
        final meetingUrl = response.data["data"]["meetingUrl"];
        return Results.success([bookingId, bookingUniqueId, meetingUrl]);
      } else {
        return Results.error("Event not registered");
      }
    } catch (e) {
      print(e);
      return Results.error(e);
    }
  }

  // Fetches all upcoming bookings
  Future<Results> getAllBookings(BookingScheduleModel bookingModel) async {
    try {
      var response = await _apiClient.request(
        requestType: RequestType.GET,
        path: '/v2/bookings?status=upcoming',
        version: '2024-08-13',
      );

      if (response.statusCode == 201) {
        final bookingId = response.data["data"]["id"];
        return Results.success(bookingId);
      } else {
        return Results.error("Event not registered");
      }
    } catch (e) {
      print(e);
      return Results.error(e);
    }
  }

  // Reschedules a booking by sending a POST request with the new start time
  Future<Results> rescheduleBooking(String bookingUniqueId, String start) async {

    try {
      var response = await _apiClient.request(
        requestType: RequestType.POST,
        path: '/v2/bookings/$bookingUniqueId/reschedule',
        data: {
          "start": start
        },
        version: '2024-08-13',
      );

      if (response.statusCode == 201) {
        final bookingId = response.data["data"]["id"];
        final bookingUniqueId = response.data["data"]["uid"];
        return Results.success([bookingId, bookingUniqueId]);
      } else {
        return Results.error("Booking is not rescheduled");
      }
    } catch (e) {
      print(e);
      return Results.error(e);
    }
  }



  // Cancels a booking by sending a POST request with a cancellation reason
  Future<Results> cancelBooking(String bookingUniqueId) async {
    if (bookingUniqueId.isEmpty) {
      print("Error: bookingUniqueId is empty");
      return Results.error("Invalid booking ID");
    }
    try {
      var response = await _apiClient.request(
        requestType: RequestType.POST,
        path: '/v2/bookings/$bookingUniqueId/cancel',
        version: '2024-08-13',
        data: {
          "cancellationReason": "test-run"
        }
      );

      if (response.statusCode == 200) {
        return Results.success("true");
      } else {
        return Results.error("Booking is not rescheduled");
      }
    } catch (e) {
      print(e);
      return Results.error("false");
    }
  }
}
