
import 'package:dio/dio.dart';
import 'package:reachx_embed/core/constants/apiConstants.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

class EmailNotificationService {
 final Dio _dio = Dio();

 Future<Results> sendEmail(Map<String, dynamic> data) async {
   try {

     final formData = FormData.fromMap(data);

     final response = await _dio.post(
        emailUrl,
       data: formData,
       options: Options(
         contentType: 'multipart/form-data',
       )
     );

     if(response.statusCode == 200 || response.statusCode == 201) {
       return Results.success("Successfully send");
     } else {
       return Results.error("Error");
     }

   } catch(e) {
     return Results.error("Error: $e");
   }
 }
}