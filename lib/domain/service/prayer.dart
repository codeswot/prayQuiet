import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/service/date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeService {
  /// not my code 😅
  static CalculatedPrayerInfo calculateNextPrayerTime(
      Map<String, dynamic> prayerTimes) {
    prayerTimes.remove('Sunrise');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final sortedPrayerTimes = prayerTimes.map((prayer, time) {
      return MapEntry(
        prayer,
        DateService.getFormartedDateWitCustomTime(
          date: now,
          customTime: time,
        ),
      );
    });

    final prayerOrder = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha\'a',
    ];

    final nextPrayerTime = prayerOrder
        .map((prayer) => sortedPrayerTimes[prayer])
        .firstWhere((prayerTime) => prayerTime!.isAfter(now),
            orElse: () => null);

    if (nextPrayerTime == null ||
        nextPrayerTime.isAfter(sortedPrayerTimes['Isha\'a']!)) {
      final nextPrayerDateTime = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        sortedPrayerTimes['Fajr']!.hour,
        sortedPrayerTimes['Fajr']!.minute,
      );
      return CalculatedPrayerInfo(nextPrayerDateTime, 'Fajr');
    }

    final nextPrayerName = sortedPrayerTimes.entries
        .firstWhere(
          (entry) => entry.value == nextPrayerTime,
        )
        .key;

    return CalculatedPrayerInfo(nextPrayerTime, nextPrayerName);
  }

  static Stream<CalculatedPrayerInfo> getNextPrayerStream(
      Map<String, dynamic> prayerTimes) async* {
    while (true) {
      final nextPrayerInfo = calculateNextPrayerTime(prayerTimes);
      final now = DateTime.now();
      yield nextPrayerInfo;

      await Future.delayed(
        const Duration(seconds: 1) -
            Duration(seconds: now.second) -
            Duration(milliseconds: now.millisecond),
      );
    }
  }

  static CalculatedPrayerInfo? getCurrentOrNextPrayer(
      Map<String, dynamic> prayers) {
    final now = DateTime.now();
    prayers.remove('Sunrise');
    for (final prayer in prayers.entries) {
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
      if (now.isAtSameMomentAs(formattedPrayerTime)) {
        return CalculatedPrayerInfo(
          formattedPrayerTime,
          prayer.key,
        );
      } else if (now.isAfter(formattedPrayerTime)) {
        final difference = now.difference(formattedPrayerTime);
        if (difference.inMinutes <= 10) {
          return CalculatedPrayerInfo(
            formattedPrayerTime,
            prayer.key,
          );
        }
      }
    }

    return null; // No current or next prayer
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
