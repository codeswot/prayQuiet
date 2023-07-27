import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class DoNotDisturbService {
  final LoggingService _logger = LoggingService();
  final DoNotDisturb _doNotDisturb = DoNotDisturb();
  Future<void> enable() async {
    try {
      await _doNotDisturb.setStatus(false);
      //test
      final res = await PrayerTimeService.getAllPrayerTime(isDebug: false);
      if (res == null) {
        _logger.error('Res is null');
        return;
      }
      final dateService = DateService();
      final Map<String, dynamic> prayers = res[dateService.getApisToday()];

      _logger.info("Attempting to enable or disable DoNotDisturb");
      prayers.remove('Sunrise');
      for (final prayer in prayers.entries) {
        final res = await NotificationService().showNotification(
          prayerName: prayer.key,
          isEnabling: true,
          prayerTime: DateService.fmt12Hr(prayer.value),
        );
        if (res) {
          //|| !res
          await Future.delayed(
            const Duration(seconds: 8),
          );
          await _doNotDisturb.setStatus(true);
          _logger.info("Do not disturb enabled");
        }
      }
    } catch (e) {
      _logger.error('Error setting do not disturb: $e');
    }
  }

//
  Future<void> disable() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final res = await PrayerTimeService.getAllPrayerTime(isDebug: false);
      if (res == null) {
        _logger.error('Res is null');
        return;
      }
      final dateService = DateService();
      final Map<String, dynamic> prayers = res[dateService.getApisToday()];

      _logger.info("Attempting to enable or disable DoNotDisturb");

      final int idx = pref.getInt("interval_type") ?? 1;
      RingerModeStatus soundMode = RingerModeStatus.silent;

      switch (idx) {
        case 0:
          soundMode = RingerModeStatus.vibrate;
          break;
        case 1:
          soundMode = RingerModeStatus.normal;
          break;
        case 2:
          soundMode = RingerModeStatus.silent;
          break;

        default:
          soundMode = RingerModeStatus.silent;
      }

      await Future.delayed(
        const Duration(seconds: 5),
      );
      await _doNotDisturb.setStatus(false);

      await SoundMode.setSoundMode(soundMode);
      _logger.info("Do not disturb disabled with mode ${soundMode.name}");

      prayers.remove('Sunrise');
      for (final prayer in prayers.entries) {
        await NotificationService().showNotification(
          prayerName: prayer.key,
          isEnabling: false,
          prayerTime: DateService.fmt12Hr(prayer.value),
        );
        // TODO: Add as'salamualiakum custom notification sound
      }
    } catch (e) {
      _logger.error('Error setting do not disturb: $e');
    }
  }
}
