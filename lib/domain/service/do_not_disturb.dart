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

      _logger.info("Attempting to enable or disable DoNotDisturb");

      final res = await NotificationService().showNotification(
        prayerName: '',
        isEnabling: true,
        prayerTime: '',
      );

      if (res) {
        //|| !res
        await Future.delayed(
          const Duration(seconds: 8),
        );
        await _doNotDisturb.setStatus(true);
        _logger.info("Do not disturb enabled");
      }
    } catch (e) {
      _logger.error('Error setting do not disturb: $e');
    }
  }

//
  Future<void> disable() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

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

      await _doNotDisturb.setStatus(false);

      await SoundMode.setSoundMode(soundMode);
      _logger.info("Do not disturb disabled with mode ${soundMode.name}");

      await NotificationService().showNotification(
        prayerName: '', //no need
        isEnabling: false,
        prayerTime: '', //no need
      );

      // TODO: Add as'salamualiakum custom notification sound
    } catch (e) {
      _logger.error('Error setting do not disturb: $e');
    }
  }
}
