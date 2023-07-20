import 'package:pray_quiet/data/api_data_fetch.dart';
import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';

import 'package:pray_quiet/domain/service/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'prayer.g.dart';

@Riverpod(keepAlive: true)
class Prayer extends _$Prayer {
  PrayerApiModel? prayerDataInfo;
  Prayers? prayers;
  bool? isLoading;
  @override
  Prayers? build() {
    isLoading = true;
    LoggingService logger = LoggingService();
    logger.info("prayer provider building.");
    AsyncValue<SharedPreferences> pref =
        ref.watch(getSharedPreferencesProvider);
    if (pref.hasValue) {
      logger.info("Attempting to fetch prayer from shared preferences.");
      final String? value = pref.value!.getString("pray_time");
      logger.info("prayer time $value");
      if (value != null) {
        prayerDataInfo = PrayerApiModel.fromRawJson(value);

        final date = DateService().getApisToday();

        final res = prayerDataInfo?.praytimes[date];

        prayers = Prayers.fromJson(res);

        logger.info("prayers fetched is $res");

        isLoading = false;
        return prayers;
      }
    }
    isLoading = false;
    return null;
  }

  Future<void> updatePrayer() async {
    try {
      isLoading = true;

      LoggingService logger = LoggingService();

      final city = await LocationService.determinePosition();
      final PrayerApiModel data = await ApiDataFetch.getPrayerTime(city);

      AsyncValue<SharedPreferences> pref =
          ref.watch(getSharedPreferencesProvider);
      logger.info("Attempting to update prayer time ...");

      pref.whenData(
        (repo) {
          repo.setString(
            "pray_time",
            data.toRawJson(),
          );
          logger.info("Prayer time updated");

          final val = repo.getString("pray_time");

          if (val != null) {
            prayerDataInfo = PrayerApiModel.fromRawJson(val);

            final date = DateService().getApisToday();

            final res = prayerDataInfo?.praytimes[date];

            prayers = Prayers.fromJson(res);

            logger.info("updated prayers fetched is $res");

            isLoading = false;
            state = prayers;
          }
        },
      );
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }
}
