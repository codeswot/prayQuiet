import 'package:native_device_timezone/native_device_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as t;

class TimeZone {
  static TimeZone? _instance;

  factory TimeZone() {
    _instance ??= TimeZone._();
    return _instance!;
  }

  TimeZone._() {
    initializeTimeZones();
  }

  Future<String> getTimeZoneName() async {
    final timezoneName =
        await NativeDeviceTimezone.timezoneName ?? 'Africa/Lagos';
    return timezoneName;
  }

  Future<t.Location> getLocation([String? timeZoneName]) async {
    if (timeZoneName == null || timeZoneName.isEmpty) {
      timeZoneName = await getTimeZoneName();
    }
    return t.getLocation(timeZoneName);
  }
}
