import 'dart:convert';

import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/settings.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';

import 'package:pray_quiet/domain/service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'prayer.g.dart';

@Riverpod(keepAlive: true)
class Prayer extends _$Prayer {
  List<PrayerInfo>? prayers;
  bool? isLoading;
  @override
  Future<List<PrayerInfo>?> build() async {
    isLoading = true;
    LoggingService logger = LoggingService();
    try {
      logger.info("prayer provider building.");
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      final bool isUseCustom = pref.value!.getBool("use_custom") ?? false;
      List<PrayerInfo> dailyPrayers;
      final v = pref.value!.getString('custom_prayers') ?? '[]';

      final List<dynamic> t = json.decode(v);
      if (isUseCustom) {
        dailyPrayers = t.map((e) => PrayerInfo.fromRawJson(e)).toList();
      } else {
        dailyPrayers = await PrayerTimeService.fetchDailyPrayerTime();
      }

      if (pref.hasValue) {
        logger.info("Attempting to fetch prayers.");

        final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

        final interval = AfterPrayerIntervalType.values[intervalIdx];

        logger.info(" ${isUseCustom ? 'Custom prayers' : 'prayers'} fetched");
        //enable service

        if (t.isEmpty) {
          final customPrayers =
              json.encode(dailyPrayers.map((e) => e.toRawJson()).toList());
          pref.value!.setString('custom_prayers', customPrayers);
        }

        final serviceEnabled = pref.value!.getBool('enable_service') ?? true;
        if (serviceEnabled) {
          BackgroundTaskScheduleService().toggle(
            prayers: dailyPrayers,
            afterPrayerInterval: interval,
            isEnabling: true,
          );
        }

        isLoading = false;
      }
      isLoading = false;

      prayers = dailyPrayers;

      return dailyPrayers;
    } catch (e) {
      logger.error('An error occured building prayers $e');
    }
    return null;
  }

  Future<void> updatePrayer() async {
    try {
      isLoading = true;

      LoggingService logger = LoggingService();

      final l = await LocationService.determinePosition();

      final dailyPrayers =
          await PrayerTimeService.fetchDailyPrayerTime(location: l);

      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      logger.info("Attempting to update prayer time ...");

      final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

      final interval = AfterPrayerIntervalType.values[intervalIdx];

      pref.whenData((repo) {
        logger.info("Prayer time updated");

        isLoading = false;
        final serviceEnabled = pref.value!.getBool('enable_service') ?? true;
        if (serviceEnabled) {
          BackgroundTaskScheduleService().toggle(
            prayers: dailyPrayers,
            afterPrayerInterval: interval,
            isEnabling: true,
          );
        }
        prayers = dailyPrayers;
      });
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  setCustom(List<PrayerInfo> customPrayers) {
    final LoggingService logger = LoggingService();
    try {
      isLoading = true;
      prayers = customPrayers;
      isLoading = false;
      logger.info('Custom prayer set');
    } catch (e) {
      isLoading = false;
      logger.error('An error occured');
    }
  }
}
