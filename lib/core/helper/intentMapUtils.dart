import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class IntentUtils {
  IntentUtils._();

  static Future<void> launchGoogleMap(String address) async {
    List<Location> locations = await locationFromAddress(address);

    if(locations.isNotEmpty) {
      double destinationLatitude= locations.first.latitude;
      double destinationLongitude = locations.first.longitude;

      final uri = Uri(
          scheme: "google.navigation",
          queryParameters: {
            'q': '$destinationLatitude, $destinationLongitude'
          }
      );
      if(await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('An error occurred');
      }
    }
  }
}