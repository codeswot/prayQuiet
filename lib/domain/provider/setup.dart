import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:flutter/services.dart';
import 'package:pray_quiet/data/position.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/style/colors.dart';
import 'package:pray_quiet/vm_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'setup.g.dart';

@Riverpod(keepAlive: true)
class Setup extends _$Setup {
  SetupState? setupComplete;
  final LoggingService _logger = LoggingService();
  @override
  SetupState build() {
    try {
      _logger.info("Setup provider building.");
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      if (pref.hasValue) {
        _logger.info(
            "Attempting to fetch if setup is completed from shared preferences.");
        final bool value = pref.value!.getBool("is-setup-complete") ?? false;
        _logger.info("is-setup-complete is $value");
        setupComplete = value ? SetupState.complete : SetupState.notStarted;
        if (setupComplete != null) {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.carmyGreen,
            ),
          );
          return setupComplete!;
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.introG,
            ),
          );
        }
        return SetupState.inProgress;
      }
      return SetupState.notStarted;
    } catch (e) {
      _logger.error('Error occured building setup $e');
      return SetupState.notStarted;
    }
  }

  Future<void> attemptSetup() async {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      _logger.info("Attempting complete setup ...");
      state = SetupState.inProgress;

      await NotificationService().requestPermissions();
      final g = await LocationService.determinePosition();

      await DoNotDisturb().openDoNotDisturbSettings();

      final dailyPrayers =
          await PrayerTimeService.fetchDailyPrayerTime(location: g);

      final dailyPrayersJson =
          json.encode(dailyPrayers.map((e) => e.toRawJson()).toList());

      Position pos = Position(lat: g.latitude, lng: g.longitude, mock: false);

      pref.whenData(
        (repo) => {
          repo.setBool("is-setup-complete", true),
          repo.setBool("enable_service", true),
          repo.setBool("use_custom", false),

          //
          repo.setString('prayers', dailyPrayersJson),
          repo.setString('custom_prayers', dailyPrayersJson),
          //
          repo.setString('position', pos.toRawJson()),
          repo.setInt('behaviour_type', 1),
          repo.setInt('interval_type', 1),

          _logger.info("Set is-setup-complete to true"),
        },
      );

      //serve
      AndroidAlarmManager.periodic(
        const Duration(hours: 20),
        3,
        bgServe,
        rescheduleOnReboot: true,
        exact: true,
        wakeup: true,
      );
      state = SetupState.complete;
    } catch (e) {
      state = SetupState.notStarted;
      _logger.error('(attemptSetup) An error occured attempting setup $e');
    }
  }

  void removeSetup() {
    AsyncValue<SharedPreferences> pref =
        ref.watch(getSharedPreferencesProvider);

    pref.whenData(
      (repo) async => {
        repo.setBool("is-setup-complete", false),
        repo.remove('position'),
        _logger.info("is-setup-complete to false"),
        state = SetupState.notStarted
      },
    );
  }
}

enum SetupState { notStarted, complete, inProgress }

extension SetupStateExtension on SetupState {
  bool get isNotStarted => this == SetupState.notStarted;
  bool get isComplete => this == SetupState.complete;
  bool get isInProgress => this == SetupState.inProgress;
}
