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
    return Consumer(
      builder: (context, ref, _) {
        final dailyPrayers = ref.watch(prayerProvider.notifier).prayers;
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

        return StreamBuilder<PrayerInfo?>(
          stream: PrayerTimeService.getCurrentOrNextPrayerStream(dailyPrayers),
          builder: (context, snapshot) {
            final currentPrayer = snapshot.data?.prayerName;

            return Column(
              children: dailyPrayers.map(
                (dailyPrayer) {
                  return DailyPrayerTile(
                    title: dailyPrayer.prayerName,
                    time: DateService.getFormartedTime12(
                        dailyPrayer.prayerDateTime),
                    currentPrayer: currentPrayer ?? 'Fajr',
                  );
                },
              ).toList(),
            );
          },
        );
      },
    );
  }
}
