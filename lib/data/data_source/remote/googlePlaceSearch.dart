import 'dart:convert';


import 'package:reachx_embed/core/env_config.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GooglePlaceSearch {

  static const apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  final Uuid uuid = const Uuid();
  late String sessionToken;

  Future<Map<String, dynamic>> getLocationResults(String input) async {

    sessionToken = uuid.v4();
    try {
      String request = "https://places.googleapis.com/v1/places:searchText";
        final response = await http.post(
          Uri.parse(request),
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': apiKey,
            'X-Goog-FieldMask': 'places.displayName,places.formattedAddress'
          },
          body: json.encode({
            "textQuery":input
          }),
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception("Failed to load predictions");
        }
          return {};
    } catch (e) {
      print("Error fetching location results: $e");
      return {};
    }
  }
}