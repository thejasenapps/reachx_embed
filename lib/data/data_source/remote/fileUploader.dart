
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FileUploader {

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> uploadFile(dynamic file, {String fileName = 'recording'}) async {
    try{
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          file as Uint8List,
          filename: fileName,
        )
      });


      Response response = await _dio.post(
        'https://media-upload-cloudinary-eight.vercel.app/upload-media',
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"}),
          onSendProgress: (int sent, int total) {
            print("Upload progress: ${(sent/ total * 100).toStringAsFixed(2)}%");
          }
        );
      if(response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      print("Unsuccessful b: $e");
      return {};
    }
  }



  Future<Map<String, dynamic>> updateFile(dynamic file, String publicId, String type, {String filename = "recording"}) async {
    try{
      final formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          file,
          filename: filename,
        ),
      });

      if(type == "audio") {
        type = "video";
      }

      Response response = await _dio.put(
          'https://media-upload-cloudinary-eight.vercel.app/update-media',
          data: formData,
          options: Options(
              headers: {"Content-Type": "multipart/form-data"}),
              queryParameters: {
                "public_id": publicId,
                "type": type
              },
              onSendProgress: (int sent, int total) {
                print("Upload progress: ${(sent/ total * 100).toStringAsFixed(2)}%");
              }
      );
      if(response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      print("Unsuccessful : $e");
      return {};
    }
  }

  Future<bool> deleteFile(String publicId, String type) async {
    try{

      if(type == "audio") {
        type = "video";
      }

      Response response = await _dio.delete(
          'https://media-upload-cloudinary-eight.vercel.app/delete-media',
          queryParameters: {
            "public_id": publicId,
            "type": type
          });

      if(response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Unsuccessful");
      return false;
    }
  }
}