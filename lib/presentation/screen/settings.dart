import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/domain/provider/settings.dart';

import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverLayoutBuilder(
          builder: (BuildContext context, SliverConstraints constraints) {
            return const CustomSliverAppBar(
              title: 'Settings',
              height: 100,
              isHome: false,
            );
          },
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                SettingsItemContainer(
                  child: Consumer(builder: (context, ref, _) {
                    final setting = ref.watch(settingsProvider.notifier);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Enable Service',
                              style: AppTypography.m3BodylLarge(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch.adaptive(
                              value: setting.serviceEnable ?? true,
                              onChanged: (v) {
                                setting.toggleService(v);
                                setState(() {});
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 2.h),
                        const SettingsDivider(),
                        SizedBox(height: 2.h),
                        const AfterPrayerBehaviour(),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                SettingsItemContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Edit Prayer Time',
                              style: AppTypography.m3BodylLarge(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CircleAvatar(
                              radius: 15.sp,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.2),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.aleGreen,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      const SettingsDivider(),
                      SizedBox(height: 2.h),
                      const AfterPrayerInterval(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
