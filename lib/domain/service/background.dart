import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:flutter/foundation.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundService {
  final DoNotDisturb _doNotDisturb = DoNotDisturb();

  final LoggingService _loggingService = LoggingService();
  Future<bool> setDoNotDisturb() async {
    if (kDebugMode) {
      print('Starting to set do not disturb');
    }
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool doneSetup = prefs.getBool('is-setup-complete') ?? false;

      if (!doneSetup) {
        if (kDebugMode) {
          print('did not attempt to set do not disturb as setup is not done');
        }
        _loggingService.debug(
          'did not attempt to set do not disturb as setup is not done',
        );
        return false;
      }
      final isPrayerTime = await PrayerTimeService.isPrayerTime();
      await _doNotDisturb.setStatus(isPrayerTime);
      if (isPrayerTime) {
        _loggingService.debug('Do not disturb is set as it is prayer time');
        if (kDebugMode) {
          print('Do not disturb is set as it is prayer time');
        }
      } else {
        _loggingService
            .debug('Do not disturb is unset as it is not prayer time');
        if (kDebugMode) {
          print('Do not disturb is unset as it is not prayer time');
        }
        if (kDebugMode) {
          print('Ending to set do not disturb');
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error setting do not disturb $e');
      }
      rethrow;
    }
  }
}
