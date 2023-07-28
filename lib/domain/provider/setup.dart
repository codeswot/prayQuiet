import 'package:do_not_disturb/do_not_disturb.dart';
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
          return setupComplete!;
        }
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
      DoNotDisturb().openDoNotDisturbSettings();

      pref.whenData(
        (repo) async => {
          await repo.setBool("is-setup-complete", true),
          logger.info("Set is-setup-complete to true"),
          state = SetupState.complete
        },
      );
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
      (repo) => {
        repo.setBool("is-setup-complete", false),
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
