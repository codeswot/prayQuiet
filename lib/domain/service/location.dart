import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray_quiet/domain/service/service.dart';

class LocationService {
  static Future<Position> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }

      final l = await Geolocator.getCurrentPosition();
      return l;
    } catch (e) {
      rethrow;
    }
  }

//
  static Future<String> getAddress() async {
    try {
      final Position l = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(l.latitude, l.longitude);

      Placemark validPlacemark = placemarks.firstWhere(
        (placemark) => placemark.locality != null && placemark.locality != '',
        orElse: () => placemarks.first,
      );

      return validPlacemark.locality ?? 'Lagos';
    } catch (e) {
      rethrow;
    }
  }
//

  static Future<bool> isServiceAvailable() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      LoggingService().error('An Error occured $e');
      return false;
    }
  }

  static Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      return false;
    }
  }
}
