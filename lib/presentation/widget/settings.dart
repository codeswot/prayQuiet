import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/domain/provider/settings.dart';
import 'package:pray_quiet/presentation/shared/context_extension.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/dialog.dart';

class SettingsItemContainer extends StatelessWidget {
  const SettingsItemContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.sp,
        horizontal: 12.sp,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        color: AppColors.secondary.withOpacity(0.1),
      ),
      child: child,
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.text.withOpacity(0.2),
      thickness: 0.3,
    );
  }
}

class AfterPrayerBehaviour extends StatefulWidget {
  const AfterPrayerBehaviour({
    super.key,
  });

  @override
  State<AfterPrayerBehaviour> createState() => _AfterPrayerBehaviourState();
}

class _AfterPrayerBehaviourState extends State<AfterPrayerBehaviour> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              'After prayer behaviour',
              style: AppTypography.m3BodylLarge(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              tooltip: 'After prayer behaviour information',
              padding: EdgeInsets.zero,
              iconSize: 10.sp,
              splashRadius: 1.sp,
              onPressed: () {
                context.showAppDialog(
                  const AppDialog(
                    title: 'After prayer behaviour',
                    description:
                        'This setting deals with the behavior of your device after prayer time. It determines whether it should be set back to ringer mode, vibrate mode, or left on silence. By default, the device is set to ringer mode after prayer time.',
                  ),
                );
              },
              icon: Icon(
                Icons.info_outline,
                color: AppColors.aleGreen,
                size: 10.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Consumer(builder: (context, ref, _) {
          final setting = ref.watch(settingsProvider.notifier);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AfterPrayerBehaviourType.values.length,
            itemBuilder: (ctx, idx) {
              final item = AfterPrayerBehaviourType.values[idx];
              return Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: GestureDetector(
                  onTap: () {
                    setting.setbehaviourType(item.index);
                    setState(() {});
                  },
                  child: SettingsItemContainer(
                    child: Row(
                      children: [
                        Icon(
                          _buildBehaviourIcon(item),
                          size: 13.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Put Device on ${item.name}',
                        ),
                        const Spacer(),
                        Radio.adaptive(
                          value: item.index,
                          groupValue: setting.behaviourType,
                          onChanged: (v) {
                            setting.setbehaviourType(v ?? item.index);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  IconData _buildBehaviourIcon(AfterPrayerBehaviourType type) {
    switch (type) {
      case AfterPrayerBehaviourType.ringer:
        return Icons.phonelink_ring_outlined;

      case AfterPrayerBehaviourType.vibrate:
        return Icons.vibration_rounded;

      case AfterPrayerBehaviourType.silence:
        return Icons.phone_android;

      default:
        return Icons.phonelink_ring_outlined;
    }
  }
}

class AfterPrayerInterval extends StatefulWidget {
  const AfterPrayerInterval({
    super.key,
  });

  @override
  State<AfterPrayerInterval> createState() => _AfterPrayerIntervalState();
}

class _AfterPrayerIntervalState extends State<AfterPrayerInterval> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              'After prayer Interval',
              style: AppTypography.m3BodylLarge(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              tooltip: 'After prayer interval information',
              padding: EdgeInsets.zero,
              iconSize: 10.sp,
              splashRadius: 1.sp,
              onPressed: () {
                context.showAppDialog(
                  const AppDialog(
                    title: 'After prayer interval',
                    description:
                        'This refers to the interval or waiting period to remove the device from "Do Not Disturb" mode after prayer. By default, the waiting period is set to 30 minutes. During this time, the device will remain in "Do Not Disturb" mode after the prayer event before automatically reverting to its normal mode of operation.',
                  ),
                );
              },
              icon: Icon(
                Icons.info_outline,
                color: AppColors.aleGreen,
                size: 10.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Consumer(builder: (context, ref, _) {
          final settings = ref.watch(settingsProvider.notifier);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AfterPrayerBehaviourType.values.length,
            itemBuilder: (ctx, idx) {
              final item = AfterPrayerIntervalType.values[idx];
              return Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: GestureDetector(
                  onTap: () {
                    settings.setIntervalType(item.index);
                    setState(() {});
                  },
                  child: SettingsItemContainer(
                    child: Row(
                      children: [
                        Icon(
                          Icons.timelapse,
                          size: 13.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _buildIntervalText(item),
                        ),
                        const Spacer(),
                        Radio.adaptive(
                          value: item.index,
                          groupValue: settings.intervalType,
                          onChanged: (v) {
                            settings.setIntervalType(v ?? item.index);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  String _buildIntervalText(AfterPrayerIntervalType type) {
    switch (type) {
      case AfterPrayerIntervalType.min15:
        return 'After 15 minutes';
      case AfterPrayerIntervalType.min30:
        return 'After 30 minutes';
      case AfterPrayerIntervalType.hr1:
        return 'After an hour';

      default:
        return 'After 15 miniutes';
    }
  }
}
