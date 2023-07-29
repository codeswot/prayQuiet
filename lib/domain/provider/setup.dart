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

  @override
  SetupState build() {
    LoggingService logger = LoggingService();
    try {
      logger.info("Setup provider building.");
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      if (pref.hasValue) {
        logger.info(
            "Attempting to fetch if setup is completed from shared preferences.");
        final bool value = pref.value!.getBool("is-setup-complete") ?? false;
        logger.info("is-setup-complete is $value");
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
      logger.error('Error occured building setup');
      return SetupState.notStarted;
    }
  }

  Future<void> attemptSetup() async {
    try {
      LoggingService logger = LoggingService();
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      logger.info("Attempting complete setup ...");
      state = SetupState.inProgress;

      await NotificationService().requestPermissions();
      await DoNotDisturb().openDoNotDisturbSettings();
      final g = await LocationService.determinePosition();

      Position pos = Position(lat: g.latitude, lng: g.longitude, mock: false);
      pref.whenData(
        (repo) => {
          repo.setBool("is-setup-complete", true),
          repo.setString('position', pos.toRawJson()),
          logger.info("Set is-setup-complete to true"),
        },
      );
      AndroidAlarmManager.periodic(
        const Duration(hours: 20),
        3,
        bgServe,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
        exact: true,
        wakeup: true,
      );
      state = SetupState.complete;
    } catch (e) {
      state = SetupState.notStarted;
      rethrow;
    }
  }

  void removeSetup() {
    LoggingService logger = LoggingService();

    AsyncValue<SharedPreferences> pref =
        ref.watch(getSharedPreferencesProvider);

    pref.whenData(
      (repo) async => {
        repo.setBool("is-setup-complete", false),
        repo.remove('position'),
        logger.info("is-setup-complete to false"),
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
