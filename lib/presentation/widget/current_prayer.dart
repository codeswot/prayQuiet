import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/domain/service/date.dart';
import 'package:pray_quiet/presentation/style/style.dart';

class CurrentPrayer extends StatelessWidget {
  const CurrentPrayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final prayerInfo = ref.watch(prayerProvider.notifier).prayerDataInfo;

      final prayers = ref.watch(prayerProvider);
      //remove Sunrise from prayer
      prayers!.toJson().remove('Sunrise');

      return StreamBuilder<CalculatedPrayerInfo>(
          stream: DateService.getNextPrayerStream(prayers.toJson()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            final nextPrayer = snapshot.data!;

            final now = DateTime.now();
            final countdownDuration = nextPrayer.dateTime.difference(now);
            return Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                  delay: Duration(milliseconds: 50),
                ),
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextPrayer.prayerName,
                    style: AppTypography.m3TitlelLarge(
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    DateService.fmt12Hr(
                        DateService.getFormartedTime(nextPrayer.dateTime)),
                    style: AppTypography.m3TitlelMedium(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '- ${DateService.formatDuration(countdownDuration)}',
                        style: AppTypography.m3BodylLarge(),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          prayerInfo?.location ?? '--',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          style: AppTypography.m3BodylLarge(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
    });
  }
}
