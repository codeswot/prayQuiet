import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray_quiet/data/position.dart' as p;
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/domain/service/timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    LoggingService logger = LoggingService();
    final tzn = await TimeZone().getTimeZoneName();

    logger.info('(getAddress) tzn ${tzn.split('/')[1]}');
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final str = pref.getString('position') ??
          '{"lat":"6.5244","lng":"3.3792","mock":"true"}';

      // logger.info("Position $str ");
      final l = p.Position.fromRawJson(str);

      List<Placemark> placemarks = await placemarkFromCoordinates(l.lat, l.lng);

      Placemark validPlacemark = placemarks.firstWhere(
        (placemark) => placemark.locality != null && placemark.locality != '',
        orElse: () => placemarks.first,
      );

      return validPlacemark.locality ?? tzn.split('/')[1];
    } catch (e) {
      logger.error('(getAddress) an error occured $e');
      return tzn.split('/')[1];
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
