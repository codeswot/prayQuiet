import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/prayer_info_model.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/domain/provider/settings.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/shared/shared.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/dialog.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class PrayerSettings extends ConsumerStatefulWidget {
  const PrayerSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrayerSettingsState();
}

class _PrayerSettingsState extends ConsumerState<PrayerSettings> {
  @override
  Widget build(BuildContext context) {
    final settingRef = ref.watch(settingsProvider.notifier);
    final prayerRef = ref.watch(prayerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withOpacity(0.4),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Prayer Settings',
              style: AppTypography.m3TitlelLarge(),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.settings,
              size: 15.sp,
              color: AppColors.secondary.withOpacity(0.5),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              Divider(thickness: 0.2.sp),
              SettingsItemContainer(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Use custom prayer time',
                              style: AppTypography.m3BodylLarge(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                              height: 15.h,
                              child: IconButton(
                                tooltip: 'use custom prayer time',
                                padding: EdgeInsets.zero,
                                iconSize: 15.sp,
                                splashRadius: 1.sp,
                                onPressed: () {
                                  context.showAppDialog(
                                    const AppDialog(
                                      title: 'Custom prayer time',
                                      description:
                                          'By enabling this option, you can input the specific prayer times observed at your masjid, allowing the app to align with your local community\'s prayer schedule. By toggling this option, you ensure that the app accurately reflects the prayer times practiced at your masjid, enhancing your prayer experience and spiritual connection.',
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.info_outline,
                                  color: AppColors.aleGreen,
                                  size: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: settingRef.useCustom ?? false,
                          onChanged: (v) async {
                            bool enabled = await serviceFirstInterceptor(
                              context,
                              settingRef.serviceEnable ?? false,
                            );
                            if (enabled) {}
                          },
                        ),
                      ],
                    ),
                    if (settingRef.useCustom ?? false) ...[
                      SizedBox(height: 2.h),
                      const SettingsDivider(),
                      SizedBox(height: 2.h),
                      Visibility.maintain(
                        visible: settingRef.useCustom ?? false,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: prayerRef.prayers.length,
                          itemBuilder: (ctx, idx) {
                            final PrayerInfo prayer = prayerRef.prayers[idx];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: GestureDetector(
                                onTap: () async {
                                  bool enabled = await serviceFirstInterceptor(
                                    context,
                                    settingRef.serviceEnable ?? false,
                                  );
                                  if (enabled) {
                                    setState(() {});
                                  }
                                },
                                child: SettingsItemContainer(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 13.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        prayer.prayerName,
                                        style: AppTypography.m3BodylLarge(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        DateService.getFormartedTime12(
                                            prayer.prayerDateTime),
                                      ),
                                      SizedBox(
                                        width: 50.w,
                                        child: TextButton(
                                          onPressed: () async {
                                            bool enabled =
                                                await serviceFirstInterceptor(
                                              context,
                                              settingRef.serviceEnable ?? false,
                                            );
                                            if (enabled) {
                                              if (context.mounted) {
                                                final d = await context
                                                    .showAppTimePicker();
                                                if (d == null) {
                                                  return;
                                                }
                                                final updatedPrayer =
                                                    _updateTime(
                                                  prayers: prayerRef.prayers,
                                                  prayer: prayer,
                                                  timeOfDay: d,
                                                );

                                                settingRef
                                                    .updateCustomPrayerTime(
                                                        updatedPrayer);
                                                setState(() {});
                                              }
                                            }

                                            //
                                          },
                                          child: const Text(
                                            'Edit',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColors.aleGreen,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<PrayerInfo> _updateTime(
      {required List<PrayerInfo> prayers,
      required PrayerInfo prayer,
      required TimeOfDay timeOfDay}) {
    return prayers.map(
      (e) {
        if (e.prayerName == prayer.prayerName) {
          return PrayerInfo(
            DateTime(
              prayer.prayerDateTime.year,
              prayer.prayerDateTime.month,
              prayer.prayerDateTime.day,
              timeOfDay.hour,
              timeOfDay.minute,
            ),
            prayer.prayerName,
          );
        } else {
          return e;
        }
      },
    ).toList();
  }
}
