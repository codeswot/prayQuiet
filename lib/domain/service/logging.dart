import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class LoggingService {
  late Logger logger;

  LoggingService() {
    logger = Logger(printer: PrettyPrinter(colors: false, methodCount: 0));
  }

  // These just passthrough to our underlying logger for now.
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.debug, message, error, stackTrace);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.error, message, error, stackTrace);
  }

  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.info, message, error, stackTrace);
  }

  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.verbose, message, error, stackTrace);
  }

  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.warning, message, error, stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.wtf, message, error, stackTrace);
  }
}

final loggingServiceProvider = Provider(((ref) {
  return LoggingService();
}));
