import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:pray_quiet/domain/service/service.dart';

class DoNotDisturbService {
  final LoggingService _logger = LoggingService();
  final DoNotDisturb _doNotDisturb = DoNotDisturb();
  Future<void> setDoNotDisturb() async {
    final now = DateTime.now();
    try {
      final res = await PrayerTimeService.getPrayerTime(false);
      final dateService = DateService();
      final Map<String, dynamic> prayers = res![dateService.getApisToday()]!;

      _logger.info("Attempting to enable or disable DoNotDisturb");
      prayers.remove('Sunrise');
      for (final prayer in prayers.entries) {
        final formattedPrayerTime = DateService.getFormartedDateWitCustomTime(
          date: now,
          customTime: prayer.value,
        );
        final later =
            formattedPrayerTime.add(const Duration(hours: 1, minutes: 35));

        if (now.isAfter(formattedPrayerTime) && now.isBefore(later)) {
          await NotificationService().showNotification(
            prayer.key,
            prayer.value,
          );
          await Future.delayed(const Duration(seconds: 8));
          await _doNotDisturb.setStatus(true);
          _logger.info("Do not disturb enabled");
        } else if (now.isAfter(later)) {
          await _doNotDisturb.setStatus(false);
          _logger.info("Do not disturb disabled");
        }
      }
    } catch (e) {
      _logger.error('Error setting do not disturb: $e');
    }
  }
}
