import 'package:dio/dio.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

class ReportUser {

  final Dio _dio = Dio();

  Future<Results> reportExpert(String expertId) async {
    try{
      var response = await _dio.post(
        "https://www.enapps.in/reachx/report-user.php",
        queryParameters: {
          'id': expertId
        }
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return Results.success("Successfully reported");
      } else {
        return Results.error("Error");
      }
    } catch(e) {
      return Results.error("Error: $e");
    }
  }
}