import 'package:geolocator/geolocator.dart';

class Location{
  double latitude=0;
  double longitude=0;


  Future<void> getCurrentLocation()async{
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission not granted');
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }

  }
  String getGoogleMapsLink() {
    return 'https://maps.google.com/?q=${latitude},${longitude}';
  }
}