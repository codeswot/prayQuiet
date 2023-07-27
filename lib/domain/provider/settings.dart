import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'settings.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  bool? serviceEnable;
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

      serviceEnable = pref.value!.getBool("enable_service") ?? true;

      behaviourType = pref.value!.getInt("behaviour_type") ?? 1;

      intervalType = pref.value!.getInt("interval_type") ?? 1;
    }
  }

  toggleService(bool value) {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      if (pref.hasValue) {
        late Prayers prayers;
        //
        final String? pTime = pref.value!.getString("pray_time");

        if (pTime != null) {
          final prayerDataInfo = PrayerApiModel.fromRawJson(pTime);

          final date = DateService().getApisToday();

          final res = prayerDataInfo.praytimes[date];

          prayers = Prayers.fromJson(res);
        }
        final int intervalIdx = pref.value!.getInt("interval_type") ?? 1;

        final interval = AfterPrayerIntervalType.values[intervalIdx];
        //
        pref.whenData((repo) async {
          _logger.info("Attempting to set service to $value.");
          serviceEnable = value;
          await repo.setBool('enable_service', value);
          BackgroundTaskScheduleService().toggle(
            prayers: prayers.toJson(),
            afterPrayerInterval: interval,
            isEnabling: value,
          );
          _logger.info("service set to $value.");
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
      final serviceEnabled = pref.value!.getBool('enable_service') ?? true;
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

  setIntervalType(int value) {
    try {
      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);

      final serviceEnabled = pref.value!.getBool('enable_service') ?? true;
      if (!serviceEnabled) {
        return;
      }

      if (pref.hasValue) {
        pref.whenData((repo) async {
          late Prayers prayers;
          //
          final String? pTime = repo.getString("pray_time");

          if (pTime != null) {
            final prayerDataInfo = PrayerApiModel.fromRawJson(pTime);

            final date = DateService().getApisToday();

            final res = prayerDataInfo.praytimes[date];

            prayers = Prayers.fromJson(res);
          }

          //
          final type = AfterPrayerIntervalType.values[value];
          _logger.info("Attempting to set Interval Type to $type");
          intervalType = value;
          await repo.setInt('interval_type', value);
          BackgroundTaskScheduleService().toggle(
            prayers: prayers.toJson(),
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
