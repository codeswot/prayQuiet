import 'dart:convert';

import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'settings.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  bool? serviceEnable;
  bool? useCustom;
  int? behaviourType;
  int? intervalType;
  final LoggingService _logger = LoggingService();

  @override
  void build() {
    _logger.info("Settings provider building.");
    AsyncValue<SharedPreferences> pref =
        ref.watch(getSharedPreferencesProvider);
    if (pref.hasValue) {
      _logger.info("Attempting to fetch previous settings.");

      serviceEnable = pref.value!.getBool("enable_service") ?? false;

      behaviourType = pref.value!.getInt("behaviour_type") ?? 1;

      intervalType = pref.value!.getInt("interval_type") ?? 1;

      useCustom = pref.value!.getBool('use_custom') ?? false;
    }
  }

  toggleService(bool value) async {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      if (pref.hasValue) {
        final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

        final interval = AfterPrayerIntervalType.values[intervalIdx];
        //
        pref.whenData((repo) async {
          _logger.info("Attempting to set service to $value.");
          serviceEnable = value;

          await repo.setBool('enable_service', value);

          _logger.info("service set to $value.");

          final useCustom = pref.value!.getBool('use_custom') ?? false;

          List<PrayerInfo> dailyPrayers;

          if (useCustom) {
            final prayerJson = pref.value!.getString('custom_prayers') ?? '[]';

            final List<dynamic> t = json.decode(prayerJson);

            final cDailyPrayers =
                t.map((e) => PrayerInfo.fromRawJson(e)).toList();

            dailyPrayers = cDailyPrayers;
            //
          } else {
            dailyPrayers = await PrayerTimeService.fetchDailyPrayerTime();
            final prayersJson =
                json.encode(dailyPrayers.map((e) => e.toRawJson()));
            pref.value!.setString('prayers', prayersJson);
          }

          BackgroundTaskScheduleService().toggle(
            prayers: dailyPrayers,
            afterPrayerInterval: interval,
            isEnabling: value,
          );
        });
      }
    } catch (e) {
      _logger.error('An Error occured toggling service $e');
    }
  }

  setbehaviourType(int value) {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      final serviceEnabled = pref.value!.getBool('enable_service') ?? false;
      if (!serviceEnabled) {
        return;
      }
      if (pref.hasValue) {
        pref.whenData((repo) async {
          final type = AfterPrayerBehaviourType.values[value];
          _logger.info("Attempting to set behaviour Type to $type");
          behaviourType = value;
          await repo.setInt('behaviour_type', value);

          _logger.info("behaviour Type set to $type.");
        });
      }
    } catch (e) {
      _logger.error('An Error occured setting behaviour type $e');
    }
  }

  setIntervalType(int value) async {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      final serviceEnabled = pref.value!.getBool('enable_service') ?? false;
      List<PrayerInfo> dailyPrayers;

      final useCustom = pref.value!.getBool('use_custom') ?? false;
      if (!serviceEnabled) {
        return;
      }

      if (pref.hasValue) {
        pref.whenData((repo) async {
          //
          final type = AfterPrayerIntervalType.values[value];
          _logger.info("Attempting to set Interval Type to $type");
          intervalType = value;
          await repo.setInt('interval_type', value);
          if (useCustom) {
            final prayerJson = pref.value!.getString('custom_prayers') ?? '[]';

            final List<dynamic> t = json.decode(prayerJson);

            final cDailyPrayers =
                t.map((e) => PrayerInfo.fromRawJson(e)).toList();

            dailyPrayers = cDailyPrayers;
          } else {
            dailyPrayers = await PrayerTimeService.fetchDailyPrayerTime();
          }
          BackgroundTaskScheduleService().toggle(
            prayers: dailyPrayers,
            afterPrayerInterval: type,
            isEnabling: true,
          );
          _logger.info("Interval Type set to $type.");
        });
      }
    } catch (e) {
      _logger.error('An Error occured setting Interval Type $e');
    }
  }

  toggleUseCustom(bool value) async {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      final Prayer pray = ref.watch(prayerProvider.notifier);

      final serviceEnabled = pref.value!.getBool('enable_service') ?? false;
      if (!serviceEnabled) {
        return;
      }
      List<PrayerInfo> dailyPrayers;
      useCustom = value;
      if (pref.hasValue) {
        pref.whenData((repo) async {
          final type = AfterPrayerIntervalType.values[intervalType ?? 0];

          await repo.setBool('use_custom', value);

          if (value) {
            final v = pref.value!.getString('custom_prayers') ?? '[]';

            final List<dynamic> t = json.decode(v);

            dailyPrayers = t.map((e) => PrayerInfo.fromRawJson(e)).toList();
            pray.setCustom(dailyPrayers);
          } else {
            pray.updatePrayer();
          }

          _logger.info(
              "use ${value ? 'custom ' : ''} prayer and interval type $type.");
        });
      }
    } catch (e) {
      _logger.error('An Error occured setting Interval Type $e');
    }
  }

  updateCustomPrayerTime(List<PrayerInfo> p) async {
    final LoggingService logger = LoggingService();
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      final Prayer pray = ref.watch(prayerProvider.notifier);
      final customPrayers = json.encode(p.map((e) => e.toRawJson()).toList());
      pref.value!.setString('custom_prayers', customPrayers);
      pray.setCustom(p);

      logger.info('custom prayer updated');
    } catch (e) {
      logger.error('Ann error occured updateCustomPrayerTime $e');
    }
  }
}

enum SetupState { notStarted, complete, inProgress }

extension SetupStateExtension on SetupState {
  bool get isNotStarted => this == SetupState.notStarted;
  bool get isComplete => this == SetupState.complete;
  bool get isInProgress => this == SetupState.inProgress;
}

enum AfterPrayerBehaviourType {
  vibrate,
  ringer,
  silence,
}

enum AfterPrayerIntervalType {
  min15,
  min30,
  hr1,
}
