import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
                  child: Column(
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
                            value: true,
                            onChanged: (v) {},
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      const SettingsDivider(),
                      SizedBox(height: 2.h),
                      const AfterPrayerBehaviour(),
                    ],
                  ),
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
