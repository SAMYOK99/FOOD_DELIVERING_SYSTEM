import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._(); // Private constructor

  static Future<void> openMapWithPosition(double latitude, double longitude) async {
    // String googleMapUrl = "https://www.google.com/maps?q=$latitude,$longitude";
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw "Could not open the map";
    }
  }

  static Future<void> openMapWithAddress(String fullAddress) async {
    String query = Uri.encodeComponent(fullAddress);
    // String googleMapUrl = "https://www.google.com/maps?q=$query";
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw "Could not open the map";
    }
  }
}
