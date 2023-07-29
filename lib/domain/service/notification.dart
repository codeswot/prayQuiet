import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initializetimezone() async {
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotificationsForDay(
      DateTime day, Map<String, dynamic> prayers) async {
    Duration offsetTime = day.timeZoneOffset;
    final LoggingService logger = LoggingService();

    for (final prayer in prayers.entries) {
      final formattedPrayerTime = DateService.getFormartedDateWitCustomTime(
        date: day,
        customTime: prayer.value,
      );

      if (day.isBefore(formattedPrayerTime)) {
        final uniqueId = DateTime.now().microsecondsSinceEpoch.hashCode +
            formattedPrayerTime.millisecondsSinceEpoch.hashCode;

        try {
          await initializetimezone();
          const androidChannel = AndroidNotificationDetails(
            'PrayQuiet',
            "Notifications",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            ongoing: false,
            visibility: NotificationVisibility.public,
          );

          var platfromChannel =
              const NotificationDetails(android: androidChannel);

          tz.TZDateTime zonedTime = tz.TZDateTime.local(
            formattedPrayerTime.year,
            formattedPrayerTime.month,
            formattedPrayerTime.day,
            formattedPrayerTime.hour,
            formattedPrayerTime.minute,
          ).subtract(offsetTime);

          await flutterLocalNotificationsPlugin.zonedSchedule(
            uniqueId,
            'Prayer Time',
            'It is time for ${prayer.key}',
            zonedTime,
            platfromChannel,
            payload: prayer.key,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );

          logger.info(
            "Notification scheduled for ${prayer.key} with id $uniqueId",
          );
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt(prayer.key, uniqueId);
        } catch (e) {
          rethrow;
        }
      }
    }
  }

  Future<bool> showNotification({
    required String prayerName,
    required String prayerTime,
    required bool isEnabling,
  }) async {
    try {
      const androidChannel = AndroidNotificationDetails(
        'PrayQuiet',
        "Notifications",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ongoing: false,
        visibility: NotificationVisibility.public,
      );

      var details = const NotificationDetails(android: androidChannel);
      await flutterLocalNotificationsPlugin.cancel(3);

      await flutterLocalNotificationsPlugin.show(
        3,
        isEnabling
            ? "$prayerName at $prayerTime"
            : "Assalamualaikum Warahmatullahi 🤲🏽",
        isEnabling
            ? 'Putting device on total silence 🤫'
            : 'Prayer successful without distraction 😌',
        details,
      );
      return true;
    } catch (e) {
      return true;
    }
  }

//
  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final LoggingService logger = LoggingService();
        logger.info("Notification received in foreground");
      },
    );
  }

  Future<bool?> requestPermissions() async {
    try {
      return flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    } catch (e) {
      return false;
    }
  }

  //
  Future<void> cancelAllNotifications() async {
    final LoggingService logger = LoggingService();
    try {
      logger.info("Attempting to cancel all notifications");

      await flutterLocalNotificationsPlugin.cancelAll();

      logger.info("All notifications cancelled");
    } catch (e) {
      logger.error("Error cancelling all notifications $e");
    }
  }
  //
}
