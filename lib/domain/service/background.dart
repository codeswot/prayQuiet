import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/vm_background.dart';

class BackgroundTaskScheduleService {
  Future<void> _scheduleTask({
    required String time,
    required int taskId,
    required bool isEnabling,
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
      isEnabling ? vmBackgroundServiceEnable : vmBackgroundServiceDisable,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );

    // Schedule the periodic alarm starting from the next day
    AndroidAlarmManager.periodic(
      const Duration(days: 1),
      taskId + 1,
      isEnabling ? vmBackgroundServiceEnable : vmBackgroundServiceDisable,
      startAt: startTime.add(const Duration(days: 1)),
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> start(Map<String, dynamic> prayers) async {
    final LoggingService logger = LoggingService();

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
      prayers.remove('Sunrise');
      for (final prayer in prayers.entries) {
        final enableTaskId = prayer.key.hashCode;

        await _scheduleTask(
          time: prayer.value,
          taskId: enableTaskId,
          isEnabling: true,
        );
        final disableDoNotDisturbDate =
            DateService.getFormartedDateWitCustomTime(
          date: DateTime.now(),
          customTime: prayer.value,
        ).add(
          const Duration(hours: 1),
        );

        final disableDoNotDisturbTime =
            DateService.getFormartedTime(disableDoNotDisturbDate);

        final disableTaskId = '${prayer.key}-disable'.hashCode;

        await _scheduleTask(
          time: disableDoNotDisturbTime,
          taskId: disableTaskId,
          isEnabling: false,
        );

        logger.info(
          'All prayers schduled with : task Id as $enableTaskId ${prayer.key} at ${DateService.fmt12Hr(prayer.value)}',
        );
      }
    } catch (e) {
      logger.error(
          '[BackgroundTaskScheduleService] : Error starting background service');
    }
  }
}
