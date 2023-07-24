import 'dart:isolate';

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
