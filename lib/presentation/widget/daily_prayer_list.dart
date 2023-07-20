import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:shimmer/shimmer.dart';

import 'daily_prayer_tile.dart';

class DailyPrayerList extends StatelessWidget {
  const DailyPrayerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      bool isLoading = ref.watch(prayerProvider.notifier).isLoading ?? false;

      if (isLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            width: double.infinity,
            color: Colors.white,
          ),
        );
      }
      final prayers = ref.watch(prayerProvider);

      return StreamBuilder<CalculatedPrayerInfo?>(
          stream:
              PrayerTimeService.getCurrentOrNextPrayerStream(prayers!.toJson()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
              );
            }

            final currentPrayer = snapshot.data!.prayerName;

            return Column(
              children: [
                DailyPrayerTile(
                  title: 'Fajr',
                  time: prayers.fajr,
                  currentPrayer: currentPrayer,
                ),
                DailyPrayerTile(
                  title: 'Dhuhr',
                  time: prayers.dhuhr,
                  currentPrayer: currentPrayer,
                ),
                DailyPrayerTile(
                  title: 'Asr',
                  time: prayers.asr,
                  currentPrayer: currentPrayer,
                ),
                DailyPrayerTile(
                  title: 'Maghrib',
                  time: prayers.maghrib,
                  currentPrayer: currentPrayer,
                ),
                DailyPrayerTile(
                  title: "Isha'a",
                  time: prayers.ishaA,
                  currentPrayer: currentPrayer,
                ),
              ],
            );
          });
    });
  }
}
