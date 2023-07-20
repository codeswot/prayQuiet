import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

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

  static String fmt12Hr(String time) {
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
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }

  static DateTime getFormartedDateWitCustomTime(
      {required DateTime date, required String customTime}) {
    try {
      final day = getFormartedDay(date);
      final month = getFormartedMonth(date);
      final year = getFormartedYear(date);

      final DateTime parsedTime =
          DateTime.parse("$year-$month-$day $customTime");

      return parsedTime;
    } catch (e) {
      rethrow;
    }
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

  static String getcountDownOrNow(DateTime dateTime) {
    final now = DateTime.now();
    final countdownDuration = dateTime.difference(now);

    if (countdownDuration.isNegative) {
      return "Now";
    } else {
      return "- ${formatDuration(countdownDuration)}";
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
