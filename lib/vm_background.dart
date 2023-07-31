import 'dart:isolate';

import 'package:pray_quiet/data/position.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/service/service.dart';

@pragma('vm:entry-point')
void vmBackgroundServiceEnable() async {
  final LoggingService logger = LoggingService();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  logger.debug(
      "[${now.toIso8601String()}] Hitting Background isolate=$isolateId function='$vmBackgroundServiceEnable' called at ${DateTime.now().toIso8601String()}");
  DoNotDisturbService().enable();
}

@pragma('vm:entry-point')
void vmBackgroundServiceDisable() async {
  final LoggingService logger = LoggingService();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  logger.debug(
      "[${now.toIso8601String()}] Hitting Background isolate=$isolateId function='$vmBackgroundServiceEnable'");
  DoNotDisturbService().disable();
}

@pragma('vm:entry-point')
void bgServe() async {
  final LoggingService logger = LoggingService();
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final isSetupComplete = pref.getBool('is-setup-complete') ?? false;
    final bool isUseCustom = pref.getBool('use_custom') ?? false;
    if (isSetupComplete && !isUseCustom) {
      logger.info('Attempting do bg sweep');
      final g = await LocationService.determinePosition();

      Position pos = Position(lat: g.latitude, lng: g.longitude, mock: false);

      pref.setString('position', pos.toRawJson());

      logger.debug('I got called at ${now.toIso8601String()}');
    }
  } catch (e) {
    logger.error('Error bgServe $e');
  }
}
