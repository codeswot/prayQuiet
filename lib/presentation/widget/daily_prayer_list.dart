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
      final prayers = ref.watch(prayerProvider);

      return prayers.when(data: (dailyPrayers) {
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
        if (dailyPrayers == null) {
          return const SizedBox();
        }

        return StreamBuilder<PrayerInfo?>(
          stream: PrayerTimeService.getCurrentOrNextPrayerStream(dailyPrayers),
          builder: (context, snapshot) {
            final currentPrayer = snapshot.data?.prayerName;

            return Column(
              children: dailyPrayers.map((dailyPrayer) {
                return DailyPrayerTile(
                  title: dailyPrayer.prayerName,
                  time: DateService.getFormartedTime12(dailyPrayer.dateTime),
                  currentPrayer: currentPrayer ?? 'Fajr',
                );
              }).toList(),
            );
          },
        );
      }, loading: () {
        return const SizedBox();
      }, error: (err, trace) {
        return const SizedBox();
      });
    });
  }
}
