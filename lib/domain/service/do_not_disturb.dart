import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:pray_quiet/domain/service/service.dart';

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
      final res = await PrayerTimeService.getAllPrayerTime(isDebug: false);
      if (res == null) {
        _logger.error('Res is null');
        return;
      }
      final dateService = DateService();
      final Map<String, dynamic> prayers = res[dateService.getApisToday()];

      _logger.info("Attempting to enable or disable DoNotDisturb");
      await Future.delayed(
        const Duration(seconds: 5),
      );
      await _doNotDisturb.setStatus(false);
      _logger.info("Do not disturb disabled");

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
