import 'package:geolocator/geolocator.dart';
import 'package:pray_quiet/data/position.dart' as p;
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_times/pray_times.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeService {
  static Future<List<PrayerInfo>> fetchDailyPrayerTime(
      {Position? location}) async {
    final LoggingService logger = LoggingService();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String value = prefs.getString("position") ??
          '{"lat":"6.5244","lng":"3.3792","mock":"true"}';
      late p.Position pos;
      if (location != null) {
        pos = p.Position(
            lat: location.latitude, lng: location.longitude, mock: false);
      } else {
        pos = p.Position.fromRawJson(value);
      }
      final DateTime now = DateTime.now();

      logger.info('gotten location at lng:${pos.lng} and lat:${pos.lat}');

      PrayerTimes prayers = PrayerTimes();
      prayers.setTimeFormat(prayers.Time24);
      prayers.setCalcMethod(prayers.MWL);
      prayers.setAsrJuristic(prayers.Shafii);
      prayers.setAdjustHighLats(prayers.AngleBased);
      List<int> offsets = [0, 0, 0, 0, 0, 0, 0];
      prayers.tune(offsets);

      List<String> prayerTimes = prayers.getPrayerTimes(
        now,
        pos.lat,
        pos.lng,
        1,
      );
      List<String> prayerNames = prayers.getTimeNames();
      List<Map<String, String>> dataMap = [];

      for (int i = 0; i < prayerTimes.length; i++) {
        dataMap.add(
          {prayerNames[i]: prayerTimes[i]},
        );
        logger.info('got prayers ${prayerNames[i]}: ${prayerTimes[i]}');
      }
      dataMap.removeWhere((entry) =>
          entry.keys.contains("Sunrise") || entry.keys.contains("Sunset"));

      List<PrayerInfo> dataList = dataMap.map((entry) {
        String prayerName = entry.keys.first;
        String prayerTime = entry.values.first;

        DateTime prayerDateTime = DateService.getFormartedDateWitCustomTime(
            date: now, customTime: prayerTime);

        return PrayerInfo(prayerDateTime, prayerName);
      }).toList();

      logger.info('Prayer fetched ');
      return dataList;
    } catch (e) {
      logger.error(
          '[PrayerTimeService](newGetAllPrayerTime): An Error occured $e');
      rethrow;
    }
  }

  static PrayerInfo? getCurrentOrNextPrayer(List<PrayerInfo> prayers) {
    final now = DateTime.now();

    for (final prayer in prayers) {
      final prayerTime = DateTime(
        now.year,
        now.month,
        now.day,
        prayer.prayerDateTime.hour,
        prayer.prayerDateTime.minute,
      );
      if (now.isBefore(prayerTime) || now.isAtSameMomentAs(prayerTime)) {
        return prayer;
      } else if (now.isAfter(prayerTime)) {
        final difference = now.difference(prayerTime);
        if (difference.inMinutes <= 10) {
          return prayer;
        }
      }
    }

    final firstPrayer = prayers.first;

    final nextDay = DateTime(
      now.year,
      now.month,
      now.day,
      firstPrayer.prayerDateTime.hour,
      firstPrayer.prayerDateTime.minute,
    ).add(const Duration(days: 1));

    return PrayerInfo(
      nextDay,
      'Fajr (Next Day)',
    );
  }

  static Stream<PrayerInfo?> getCurrentOrNextPrayerStream(
      List<PrayerInfo> prayers) async* {
    while (true) {
      final now = DateTime.now();
      final currentOrNextPrayer = getCurrentOrNextPrayer(prayers);
      yield currentOrNextPrayer;

      await Future.delayed(
        const Duration(seconds: 1) -
            Duration(seconds: now.second) -
            Duration(milliseconds: now.millisecond),
      );
    }
  }
}
