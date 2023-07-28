import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_times/pray_times.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeService {
  static Future<List<PrayerInfo>> fetchDailyPrayerTime() async {
    final LoggingService logger = LoggingService();
    try {
      final DateTime now = DateTime.now();
      logger
          .info('(fetchDailyPrayerTime) starting at ${now.toIso8601String()} ');
      final pos = await LocationService.determinePosition();
      logger.info(
          'gotten location at lng:${pos.longitude} and lat:${pos.latitude}');

      PrayerTimes prayers = PrayerTimes();
      prayers.setTimeFormat(prayers.Time24);
      prayers.setCalcMethod(prayers.MWL);
      prayers.setAsrJuristic(prayers.Shafii);
      prayers.setAdjustHighLats(prayers.AngleBased);
      List<int> offsets = [0, 0, 0, 0, 0, 0, 0];
      prayers.tune(offsets);

      List<String> prayerTimes = prayers.getPrayerTimes(
        now,
        pos.latitude,
        pos.longitude,
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

  static Future<Map<String, dynamic>?> getAllPrayerTime(
      {required bool isDebug}) async {
    final LoggingService logger = LoggingService();
    try {
      if (isDebug) {
        final debugTodayDate = DateService().getApisToday();
        final debugTommorowDate = DateService().getApisTomorrow();
        logger.info("Debug date is $debugTodayDate");
        return PrayerApiModel(
          location: "Debug Location",
          calculationMethod: "Debug Calculation Method",
          asrjuristicMethod: "Debug Asr Juristic Method",
          praytimes: {
            debugTodayDate: {
              "Fajr": "08:18",
              "Sunrise": "08:00",
              "Dhuhr": "08:20",
              "Asr": "08:23",
              "Maghrib": "08:26",
              "Isha'a": "08:29"
            },
            debugTommorowDate: {
              "Fajr": "05:00",
              "Sunrise": "05:10",
              "Dhuhr": "05:20",
              "Asr": "05:30",
              "Maghrib": "05:40",
              "Isha'a": "05:50",
            },
          },
        ).praytimes;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? value = prefs.getString("pray_time");
      if (value != null) {
        final PrayerApiModel prayerDataInfo = PrayerApiModel.fromRawJson(value);
        return prayerDataInfo.praytimes;
      }
    } catch (e) {
      logger.error('An Error occured getPrayerTime $e');
    }
    return null;
  }

  static Future<PrayerInfo> getNextPrayer() async {
    try {
      final now = DateTime.now();
      final Map<String, dynamic>? prayerDataInfo =
          await getAllPrayerTime(isDebug: false);
      if (prayerDataInfo != null) {
        final date = DateService().getApisToday();
        final prayers = prayerDataInfo[date];
        prayers.remove('Sunrise');
        for (final prayer in prayers.entries) {
          // get the next prayer
          final formattedPrayerTime = DateService.getFormartedDateWitCustomTime(
            date: now,
            customTime: prayer.value,
          );

          if (now.isBefore(formattedPrayerTime)) {
            return PrayerInfo(
              formattedPrayerTime,
              prayer.key,
            );
          }
        }

        final lastPrayer = prayers.entries.last;
        if (lastPrayer.key == "Isha'a") {
          final nextDay = now.add(const Duration(days: 1));
          final nextDayFajrTime = DateService.getFormartedDateWitCustomTime(
            date: nextDay,
            customTime: prayers['Fajr'],
          );

          return PrayerInfo(
            nextDayFajrTime,
            'Fajr',
          );
        }
      }

      return PrayerInfo(
        DateTime.now(),
        'Fajr',
      );
    } catch (e) {
      rethrow;
    }
  }

  static PrayerInfo? getCurrentOrNextPrayer(List<PrayerInfo> prayers) {
    final now = DateTime.now();

    PrayerInfo? nextPrayer;

    for (final prayer in prayers) {
      if (now.isBefore(prayer.dateTime) ||
          now.isAtSameMomentAs(prayer.dateTime)) {
        // If the current time is before or at the same time as the next prayer, return it.
        return prayer;
      } else if (now.isAfter(prayer.dateTime)) {
        final difference = now.difference(prayer.dateTime);
        if (difference.inMinutes <= 10) {
          // If the current time is within 10 minutes after the prayer, return it.
          return prayer;
        }
      }
    }

    final lastPrayer = prayers.last;
    if (lastPrayer.prayerName == "Isha") {
      final nextDay = now.add(const Duration(days: 1));

      return PrayerInfo(
        nextDay,
        'Fajr (Next Day)',
      );
    }

    return nextPrayer;
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

  static Future<bool> isPrayerTime() async {
    final now = DateTime.now();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = prefs.getString('pray_time')!;

    final model = PrayerApiModel.fromRawJson(res);
    final date = DateService().getApisToday();

    final prayers = model.praytimes[date];
    prayers.remove('Sunrise');
    for (final prayer in prayers.entries) {
      final DateTime formattedPrayerTime =
          DateService.getFormartedDateWitCustomTime(
        date: now,
        customTime: prayer.value,
      );

      if (formattedPrayerTime.isAtSameMomentAs(now)) {
        return true;
      }
    }
    return false;
  }
}
