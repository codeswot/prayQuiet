import 'dart:isolate';

import 'domain/service/service.dart';

@pragma('vm:entry-point')
void vmBackgroundService() async {
  final LoggingService logger = LoggingService();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  logger.debug(
      "[$now] Hitting Background isolate=$isolateId function='$vmBackgroundService'");
  DoNotDisturbService().setDoNotDisturb();
}
