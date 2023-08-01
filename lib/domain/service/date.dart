import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:pray_quiet/domain/service/service.dart';

class DateService {
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat('E d MMM');

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
    final LoggingService logger = LoggingService();
    try {
      final day = getFormartedDay(date);
      final month = getFormartedMonth(date);
      final year = getFormartedYear(date);

      final DateTime parsedTime =
          DateTime.parse("$year-$month-$day $customTime");
      logger.info('parsed Date is $parsedTime');
      return parsedTime;
    } catch (e) {
      logger.error('an error occured getFormartedDateWitCustomTime $e');
      rethrow;
    }
  }

  static getFormartedTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  static getFormartedTime12(DateTime date) {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(date);
  }

  static getFormartedHijriDate(DateTime date) {
    HijriCalendar hijriCalendar = HijriCalendar.fromDate(date);

    return "${hijriCalendar.hDay}-${hijriCalendar.hMonth}-${hijriCalendar.hYear}";
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
