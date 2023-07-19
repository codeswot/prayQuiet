import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';

class DateService {
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat('E d MMM');

  String getApisToday() {
    String formattedDate = dateFormat.format(now);
    return formattedDate;
  }

  String getApisTomorrow() {
    String formattedDate = dateFormat.format(now.add(const Duration(days: 1)));
    return formattedDate;
  }

  String getApisYesterday() {
    String formattedDate =
        dateFormat.format(now.subtract(const Duration(days: 1)));
    return formattedDate;
  }

  static fmt12Hr(String time) {
    final now = DateTime.now();
    final day = getFormartedDay(now);
    final month = getFormartedMonth(now);
    final year = getFormartedYear(now);
    final DateTime parsedTime = DateTime.parse("$year-$month-$day $time");

    final DateFormat formatter = DateFormat('hh:mm a');
    final String formatted = formatter.format(parsedTime);
    return formatted;
  }

  static fmt24Hr(String time) {
    final now = DateTime.now();
    final day = getFormartedDay(now);
    final month = getFormartedMonth(now);
    final year = getFormartedYear(now);
    final DateTime parsedTime = DateTime.parse("$year-$month-$day $time");

    final DateFormat formatter = DateFormat('HH:mm');
    final String formatted = formatter.format(parsedTime);
    return formatted;
  }

  static getFormartedMonth(DateTime date) {
    final DateFormat formatter = DateFormat('MM');
    return formatter.format(date);
  }

  static getFormartedDay(DateTime date) {
    final DateFormat formatter = DateFormat('dd');
    return formatter.format(date);
  }

  static getFormartedYear(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy');
    return formatter.format(date);
  }

  static getFormartedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static getFormartedTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  static getFormartedHijriDate(DateTime date) {
    HijriCalendar hijriCalendar = HijriCalendar.fromDate(date);

    return "${hijriCalendar.hDay}-${hijriCalendar.hMonth}-${hijriCalendar.hYear}";
  }

  static isBefore(String time) {
    final now = DateTime.now();
    final day = getFormartedDay(now);
    final month = getFormartedMonth(now);
    final year = getFormartedYear(now);
    final DateTime parsedTime = DateTime.parse("$year-$month-$day $time");

    return parsedTime.isBefore(now);
  }

  static isAfter(String time) {
    final now = DateTime.now();
    final day = getFormartedDay(now);
    final month = getFormartedMonth(now);
    final year = getFormartedYear(now);
    final DateTime parsedTime = DateTime.parse("$year-$month-$day $time");

    return parsedTime.isAfter(now);
  }

  static countdownTo(DateTime date) {
    final DateTime parsedTime = DateTime.parse(date.toString());

    return parsedTime.difference(date).inHours;
  }

  /// not my code 😅
  static CalculatedPrayerInfo calculateNextPrayerTime(
      Map<String, dynamic> prayerTimes) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final sortedPrayerTimes = prayerTimes.map((prayer, time) {
      final prayerTime = DateFormat('HH:mm').parse(time);
      return MapEntry(
        prayer,
        DateTime(
          now.year,
          now.month,
          now.day,
          prayerTime.hour,
          prayerTime.minute,
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

  static calculateCurrentPrayer() {}
  static Stream<CalculatedPrayerInfo> getNextPrayerStream(
      Map<String, dynamic> prayerTimes) async* {
    while (true) {
      final nextPrayerInfo = calculateNextPrayerTime(prayerTimes);
      final now = DateTime.now();

      yield nextPrayerInfo;

      await Future.delayed(const Duration(seconds: 1) -
          Duration(seconds: now.second) -
          Duration(milliseconds: now.millisecond));
    }
  }

  static String? getCurrentOrNextPrayer(Map<String, dynamic> prayers) {
    final now = DateTime.now();
    final currentTime = DateFormat('HH:mm').format(now);

    for (final prayer in prayers.entries) {
      final prayerTime = DateFormat('HH:mm').parse(prayer.value);
      final formattedPrayerTime = DateFormat('HH:mm').format(DateTime(
        now.year,
        now.month,
        now.day,
        prayerTime.hour,
        prayerTime.minute,
      ));

      if (currentTime == formattedPrayerTime) {
        return prayer.key; // Current prayer
      } else if (currentTime.compareTo(formattedPrayerTime) < 0) {
        return prayer.key; // Next prayer
      }
    }

    return null; // No current or next prayer
  }

  static Stream<String?> getCurrentOrNextPrayerStream(
      Map<String, dynamic> prayers) async* {
    while (true) {
      final currentOrNextPrayer = getCurrentOrNextPrayer(prayers);
      yield currentOrNextPrayer;
      await Future.delayed(const Duration(minutes: 10));
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
