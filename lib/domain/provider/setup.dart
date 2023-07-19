import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:pray_quiet/data/api_data_fetch.dart';
import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';

import 'package:pray_quiet/domain/service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'setup.g.dart';

@Riverpod(keepAlive: true)
class Setup extends _$Setup {
  SetupState? setupComplete;
  @override
  SetupState build() {
    LoggingService logger = LoggingService();
    logger.info("Setup provider building.");
    AsyncValue<SharedPreferences> pref =
        ref.watch(getSharedPreferencesProvider);
    if (pref.hasValue) {
      logger.info(
          "Attempting to fetch if setup is completed from shared preferences.");
      final bool value = pref.value!.getBool("is-setup-complete") ?? false;
      logger.info("is-setup-complete is $value");
      setupComplete = value ? SetupState.complet : SetupState.notStarted;
      if (setupComplete != null) {
        return setupComplete!;
      }
    }
    return SetupState.notStarted;
  }

  Future<void> attemptSetup() async {
    try {
      LoggingService logger = LoggingService();

      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      logger.info("Attempting complete setup ...");
      state = SetupState.inProgress;
      await DoNotDisturb().openDoNotDisturbSettings();
      final city = await LocationService.determinePosition();
      final PrayerApiModel data = await ApiDataFetch.getPrayerTime(city);

      logger.info("Prayer time fetched for $city is ${data.toRawJson()}");

      pref.whenData((repo) => {
            repo.setString(
              "pray_time",
              data.toRawJson(),
            ),
            repo.setBool("is-setup-complete", true),
            logger.info("Set is-setup-complete to true"),
            state = SetupState.complet
          });
    } catch (e) {
      state = SetupState.notStarted;
      rethrow;
    }
  }

  void removeSetup() {
    LoggingService logger = LoggingService();

    AsyncValue<SharedPreferences> pref =
        ref.watch(getSharedPreferencesProvider);
    pref.whenData((repo) => {
          repo.setBool("is-setup-complete", false),
          logger.info("is-setup-complete to false"),
          state = SetupState.notStarted
        });
  }
}

enum SetupState { notStarted, inProgress, complet }

extension SetupStateExtension on SetupState {
  bool get isNotStarted => this == SetupState.notStarted;
  bool get isInProgress => this == SetupState.inProgress;
  bool get isComplete => this == SetupState.complet;
}
