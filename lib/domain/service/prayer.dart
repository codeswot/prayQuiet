import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeService {
  static Future<Map<String, dynamic>?> getPrayerTime(bool isDebug) async {
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
              "Fajr": "08:46",
              "Sunrise": "08:21",
              "Dhuhr": "09:40",
              "Asr": "11:30",
              "Maghrib": "12:55",
              "Isha'a": "13:40"
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
      rethrow;
    }
    return null;
  }

  static Future<CalculatedPrayerInfo> getNextPrayer() async {
    try {
      final now = DateTime.now();
      final Map<String, dynamic>? prayerDataInfo = await getPrayerTime(true);
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
            return CalculatedPrayerInfo(
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

          return CalculatedPrayerInfo(
            nextDayFajrTime,
            'Fajr',
          );
        }
      }

      return CalculatedPrayerInfo(
        DateTime.now(),
        'Fajr',
      );
    } catch (e) {
      rethrow;
    }
  }

  static CalculatedPrayerInfo? getCurrentOrNextPrayer(
      Map<String, dynamic> prayers) {
    final now = DateTime.now();

    prayers.remove('Sunrise');

    CalculatedPrayerInfo? nextPrayer;

    for (final prayer in prayers.entries) {
      final formattedPrayerTime = DateService.getFormartedDateWitCustomTime(
        date: now,
        customTime: prayer.value,
      );

      if (now.isBefore(formattedPrayerTime) ||
          now.isAtSameMomentAs(formattedPrayerTime)) {
        // If the current time is before or at the same time as the next prayer, return it.
        return CalculatedPrayerInfo(
          formattedPrayerTime,
          prayer.key,
        );
      } else if (now.isAfter(formattedPrayerTime)) {
        final difference = now.difference(formattedPrayerTime);
        if (difference.inMinutes <= 10) {
          // If the current time is within 10 minutes after the prayer, return it.
          return CalculatedPrayerInfo(
            formattedPrayerTime,
            prayer.key,
          );
        }
      }
    }

    final lastPrayer = prayers.entries.last;
    if (lastPrayer.key == "Isha'a") {
      final nextDay = now.add(const Duration(days: 1));
      final nextDayFajrTime = DateService.getFormartedDateWitCustomTime(
        date: nextDay,
        customTime: prayers['Fajr'],
      );

      return CalculatedPrayerInfo(
        nextDayFajrTime,
        'Fajr (Next Day)',
      );
    }

    return nextPrayer;
  }

  static Stream<CalculatedPrayerInfo?> getCurrentOrNextPrayerStream(
      Map<String, dynamic> prayers) async* {
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
