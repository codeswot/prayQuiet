import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/settings.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/vm_background.dart';

class BackgroundTaskScheduleService {
  final LoggingService _logger = LoggingService();

  Future<void> _scheduleTask({
    required String time,
    required int taskId,
    required bool isPrayerTime,
  }) async {
    final now = DateTime.now();

    final day = DateService.getFormartedDay(now);
    final month = DateService.getFormartedMonth(now);
    final year = DateService.getFormartedYear(now);
    final startTime = DateTime.parse("$year-$month-$day $time");

    // Calculate the initial delay until the startAt time
    Duration initialDelay = startTime.difference(now);
    if (initialDelay.isNegative) {
      // If the startAt time is in the past, schedule it for the next day
      initialDelay = initialDelay + const Duration(days: 1);
    }

    // Schedule the first alarm to start at the specified startAt time
    AndroidAlarmManager.oneShot(
      initialDelay,
      taskId,
      isPrayerTime ? vmBackgroundServiceEnable : vmBackgroundServiceDisable,
      rescheduleOnReboot: true,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
    );

    // Schedule the periodic alarm starting from the next day
    AndroidAlarmManager.periodic(
      const Duration(days: 1),
      taskId + 1,
      isPrayerTime ? vmBackgroundServiceEnable : vmBackgroundServiceDisable,
      startAt: startTime.add(const Duration(days: 1)),
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> toggle({
    required List<PrayerInfo> prayers,
    required bool isEnabling,
    required AfterPrayerIntervalType afterPrayerInterval,
  }) async {
    try {
      final Duration duration = _duration(afterPrayerInterval);

      for (final prayer in prayers) {
        final prayerTaskId = prayer.prayerName.hashCode;
        final afterPrayerTaskId = '${prayer.prayerName}-after'.hashCode;

        final prayerTime = DateService.getFormartedTime(prayer.prayerDateTime);

        if (isEnabling) {
          await _scheduleTask(
            time: prayerTime,
            taskId: prayerTaskId,
            isPrayerTime: true,
          );
          final afterPrayerDate = prayer.prayerDateTime.add(duration);

          final afterPrayerTime = DateService.getFormartedTime(afterPrayerDate);

          await _scheduleTask(
            time: afterPrayerTime,
            taskId: afterPrayerTaskId,
            isPrayerTime: false,
          );

          _logger.info(
            'All prayers schduled with : task Id as $prayerTaskId ${prayer.prayerName} at ${DateService.getFormartedTime12(prayer.prayerDateTime)} with after interval ${duration.inMinutes} as $afterPrayerInterval',
          );
        } else {
          await _unScheduleTask(prayerTaskId);
          await _unScheduleTask(afterPrayerTaskId);

          _logger.info(
            'All prayers unSchduled with : task Id as $prayerTaskId ${prayer.prayerName} at ${DateService.getFormartedTime12(prayer.prayerDateTime)}',
          );
        }
      }
    } catch (e) {
      _logger.error(
          '[BackgroundTaskScheduleService] start : Error starting background service $e');
    }
  }

  Future<void> _unScheduleTask(int id) async {
    try {
      await AndroidAlarmManager.cancel(id);
    } catch (e) {
      _logger.error(
          '[BackgroundTaskScheduleService] stop : Error starting background service $e');
    }
  }

  Duration _duration(AfterPrayerIntervalType type) {
    final LoggingService logger = LoggingService();
    try {
      switch (type) {
        case AfterPrayerIntervalType.min15:
          return const Duration(minutes: 15);

        case AfterPrayerIntervalType.min30:
          return const Duration(minutes: 30);

        case AfterPrayerIntervalType.hr1:
          return const Duration(hours: 1);

        default:
          return const Duration(minutes: 15);
      }
    } catch (e) {
      logger.error('An error occured setting interval $e');
      return const Duration(minutes: 15);
    }
  }
}
