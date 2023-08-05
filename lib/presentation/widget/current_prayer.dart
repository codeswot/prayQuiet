import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/style/style.dart';

class CurrentPrayer extends StatelessWidget {
  const CurrentPrayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Consumer(
      builder: (context, ref, _) {
        final dailyPrayers = ref.watch(prayerProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 10000),
            StreamBuilder<PrayerInfo?>(
              stream:
                  PrayerTimeService.getCurrentOrNextPrayerStream(dailyPrayers),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final nextPrayer = snapshot.data!;

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
                          fontSize: 40.sp,
                        ),
                      ),
                      Text(
                        DateService.getFormartedTime12(
                          nextPrayer.prayerDateTime,
                        ),
                        style: AppTypography.m3TitlelMedium(),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateService.getcountDownOrNow(
                              DateTime(
                                now.year,
                                now.month,
                                now.day,
                                nextPrayer.prayerDateTime.hour,
                                nextPrayer.prayerDateTime.minute,
                              ),
                            ),
                            style: AppTypography.m3BodylLarge(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
            Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 510),
                  delay: Duration(milliseconds: 65),
                ),
              ],
              child: FutureBuilder<String>(
                  future: LocationService.getAddress(),
                  builder: (context, snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: Text(
                            snapshot.data ?? '--',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            style: AppTypography.m3BodylLarge(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "${DateService.getFormartedHijriDate(
                            dailyPrayers.first.prayerDateTime,
                          )} AH",
                          style: AppTypography.m3BodylMedium(),
                        )
                      ],
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
