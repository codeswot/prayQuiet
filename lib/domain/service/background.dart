import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
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
      exact: true,
      wakeup: true,
    );

    // Schedule the periodic alarm starting from the next day
    AndroidAlarmManager.periodic(
      const Duration(days: 1),
      taskId + 1,
      isPrayerTime ? vmBackgroundServiceEnable : vmBackgroundServiceDisable,
      startAt: startTime.add(const Duration(days: 1)),
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> toggle({
    required Map<String, dynamic> prayers,
    required bool isEnabling,
    required AfterPrayerIntervalType afterPrayerInterval,
  }) async {
    try {
//       //test - start
//       final res = await PrayerTimeService.getAllPrayerTime(isDebug: false);
//       if (res == null) {
//         logger.error('Res is null');
//         return;
//       }
//       final dateService = DateService();
//       final Map<String, dynamic> prayers = res[dateService.getApisToday()];
// //test - end
      Duration duration = const Duration(minutes: 30);

      switch (afterPrayerInterval) {
        case AfterPrayerIntervalType.min15:
          duration = const Duration(minutes: 15);
          break;
        case AfterPrayerIntervalType.min30:
          duration = const Duration(minutes: 30);
          break;
        case AfterPrayerIntervalType.hr1:
          duration = const Duration(hours: 1);
          break;
        default:
          duration = const Duration(minutes: 15);
      }
      prayers.remove('Sunrise');
      for (final prayer in prayers.entries) {
        final prayerTaskId = prayer.key.hashCode;
        final afterPrayerTaskId = '${prayer.key}-after'.hashCode;

        if (isEnabling) {
          await _scheduleTask(
            time: prayer.value,
            taskId: prayerTaskId,
            isPrayerTime: true,
          );
          final disableDoNotDisturbDate =
              DateService.getFormartedDateWitCustomTime(
            date: DateTime.now(),
            customTime: prayer.value,
          ).add(duration);

          final disableDoNotDisturbTime =
              DateService.getFormartedTime(disableDoNotDisturbDate);

          await _scheduleTask(
            time: disableDoNotDisturbTime,
            taskId: afterPrayerTaskId,
            isPrayerTime: false,
          );

          _logger.info(
            'All prayers schduled with : task Id as $prayerTaskId ${prayer.key} at ${DateService.fmt12Hr(prayer.value)} with after interval ${duration.inMinutes} as $afterPrayerInterval',
          );
        } else {
          await _unScheduleTask(prayerTaskId);
          await _unScheduleTask(afterPrayerTaskId);

          _logger.info(
            'All prayers unSchduled with : task Id as $prayerTaskId ${prayer.key} at ${DateService.fmt12Hr(prayer.value)}',
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
}
