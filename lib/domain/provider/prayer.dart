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
  List<PrayerInfo> prayers = [];
  List<PrayerInfo> customPrayers = [];
  bool? isLoading;
  final LoggingService _logger = LoggingService();

  @override
  List<PrayerInfo> build() {
    isLoading = true;
    try {
      _logger.info("prayer provider building.");
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      final bool isUseCustom = pref.value!.getBool("use_custom") ?? false;

      List<PrayerInfo> dailyPrayers;
      String prayerJson;
      List<dynamic> t;

      if (isUseCustom) {
        prayerJson = pref.value!.getString('custom_prayers') ?? '[]';
        t = json.decode(prayerJson);
        dailyPrayers = t.map((e) => PrayerInfo.fromRawJson(e)).toList();
      } else {
        prayerJson = pref.value!.getString('prayers') ?? '[]';
        t = json.decode(prayerJson);
        dailyPrayers = t.map((e) => PrayerInfo.fromRawJson(e)).toList();
      }

      if (pref.hasValue) {
        _logger.info("Attempting to fetch prayers.");

        final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

        final interval = AfterPrayerIntervalType.values[intervalIdx];

        _logger.info(" ${isUseCustom ? 'Custom prayers' : 'prayers'} fetched");
        //enable service
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
      _logger.error('An error occured building prayers $e');
    }
    return [];
  }

  Future<void> updatePrayer() async {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      final useCustom = pref.value!.getBool('use_custom') ?? true;
      if (useCustom) {
        return;
      }
      isLoading = true;

      final l = await LocationService.determinePosition();

      final dailyPrayers =
          await PrayerTimeService.fetchDailyPrayerTime(location: l);

      _logger.info("Attempting to update prayer time ...");

      final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

      final interval = AfterPrayerIntervalType.values[intervalIdx];

      pref.whenData((repo) {
        _logger.info("Prayer time updated");
        isLoading = false;
        final serviceEnabled = pref.value!.getBool('enable_service') ?? true;
        if (serviceEnabled) {
          BackgroundTaskScheduleService().toggle(
            prayers: dailyPrayers,
            afterPrayerInterval: interval,
            isEnabling: true,
          );
        }
        //save to DB
        prayers = dailyPrayers;
      });
    } catch (e) {
      isLoading = false;
      _logger.error('An error occured updating prayer $e');
    }
  }

  setCustom(List<PrayerInfo> customPrayers) {
    final LoggingService logger = LoggingService();
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      isLoading = true;

      final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

      final interval = AfterPrayerIntervalType.values[intervalIdx];

      prayers = customPrayers;
      isLoading = false;
      final serviceEnabled = pref.value!.getBool('enable_service') ?? true;
      if (serviceEnabled) {
        BackgroundTaskScheduleService().toggle(
          prayers: customPrayers,
          afterPrayerInterval: interval,
          isEnabling: true,
        );
      }
      logger.info('Custom prayer set');
    } catch (e) {
      isLoading = false;
      logger.error('An error occured setting custom prayer $e');
    }
  }
}
