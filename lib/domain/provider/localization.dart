import 'package:flutter/material.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'localization.g.dart';

@Riverpod(keepAlive: true)
class Localization extends _$Localization {
  final LoggingService _logger = LoggingService();
  @override
  Locale build() {
    try {
      _logger.info("Localization provider building.");
      // AsyncValue<SharedPreferences> pref =
      //     ref.watch(getSharedPreferencesProvider);

      return const Locale('en');
    } catch (e) {
      _logger.error('Error occured building Localization $e');
      return const Locale('en');
    }
  }
}
