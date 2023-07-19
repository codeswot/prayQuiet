import 'package:pray_quiet/data/prayer_api_model.dart';
import 'package:pray_quiet/domain/provider/shared_pref.dart';
import 'package:pray_quiet/domain/service/date.dart';

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
      LoggingService logger = LoggingService();

      // AsyncValue<SharedPreferences> pref =
      //     ref.watch(getSharedPreferencesProvider);
      logger.info("Attempting to update prayer ...");
    } catch (e) {
      state = null;
      rethrow;
    }
  }
}
