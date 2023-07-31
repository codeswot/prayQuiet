import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initializetimezone() async {
    tz.initializeTimeZones();
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
            ? "Time for prayer"
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
