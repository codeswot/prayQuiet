import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/app_locale.dart';
import 'package:pray_quiet/domain/provider/settings.dart';
import 'package:pray_quiet/presentation/shared/context_extension.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/dialog.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class SettingsItemContainer extends StatelessWidget {
  const SettingsItemContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.sp,
          horizontal: 12.sp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sp),
          color: AppColors.secondary.withOpacity(
            0.2,
          ),
        ),
        child: child,
      ),
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
      color: Theme.of(context).colorScheme.onSurface,
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
              AppLocale.afterPrayerBehaviour.getString(context),
              style: AppTypography.m3BodylLarge(
                context,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 3.w),
            SizedBox(
              width: 15.w,
              height: 15.h,
              child: IconButton(
                tooltip: AppLocale.afterPrayerBehaviourInfo.getString(context),
                padding: EdgeInsets.zero,
                iconSize: 15.sp,
                splashRadius: 1.sp,
                onPressed: () {
                  context.showAppDialog(
                    AppDialog(
                      title: AppLocale.afterPrayerBehaviour.getString(context),
                      description:
                          AppLocale.afterPrayerBehaviourDesc.getString(context),
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
        Consumer(
          builder: (context, ref, _) {
            final settings = ref.watch(settingsProvider.notifier);

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AfterPrayerBehaviourType.values.length,
              itemBuilder: (ctx, idx) {
                final item = AfterPrayerBehaviourType.values[idx];
                return Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: GestureDetector(
                    onTap: () async {
                      bool enabled = await serviceFirstInterceptor(
                        context,
                        settings.serviceEnable ?? false,
                      );
                      if (enabled) {
                        settings.setbehaviourType(item.index);
                        setState(() {});
                      }
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
                            '${AppLocale.putDeviceOn.getString(context)} ${item.name}',
                          ),
                          const Spacer(),
                          Radio.adaptive(
                            value: item.index,
                            groupValue: settings.behaviourType,
                            onChanged: (v) async {
                              bool enabled = await serviceFirstInterceptor(
                                context,
                                settings.serviceEnable ?? false,
                              );
                              if (enabled) {
                                settings.setbehaviourType(v ?? item.index);
                                setState(() {});
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
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
              AppLocale.afterPrayerInterval.getString(context),
              style: AppTypography.m3BodylLarge(
                context,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 3.w),
            SizedBox(
              width: 15.w,
              height: 15.h,
              child: IconButton(
                tooltip: AppLocale.afterPrayerIntervalInfo.getString(context),
                padding: EdgeInsets.zero,
                iconSize: 15.sp,
                splashRadius: 1.sp,
                onPressed: () {
                  context.showAppDialog(
                    AppDialog(
                      title:
                          AppLocale.afterPrayerIntervalInfo.getString(context),
                      description:
                          AppLocale.afterPrayerIntervalDesc.getString(context),
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
        Consumer(builder: (context, ref, _) {
          final settings = ref.watch(settingsProvider.notifier);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AfterPrayerBehaviourType.values.length,
            itemBuilder: (ctx, idx) {
              final item = AfterPrayerIntervalType.values[idx];
              return Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: GestureDetector(
                  onTap: () async {
                    final enabled = await serviceFirstInterceptor(
                      context,
                      settings.serviceEnable ?? false,
                    );
                    if (enabled) {
                      settings.setIntervalType(item.index);
                      setState(() {});
                    }
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
                          onChanged: (v) async {
                            final enabled = await serviceFirstInterceptor(
                              context,
                              settings.serviceEnable ?? false,
                            );
                            if (enabled) {
                              settings.setIntervalType(v ?? item.index);
                              setState(() {});
                            }
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
    bool isEnglish = localization.getLanguageName() == 'English';
    String after = AppLocale.after.getString(context);
    String min = AppLocale.minute.getString(context);
    String hour = AppLocale.hour.getString(context);
    switch (type) {
      case AfterPrayerIntervalType.min15:
        return isEnglish ? '$after 15 $min' : '$after $min 15';
      case AfterPrayerIntervalType.min30:
        return isEnglish ? '$after 30 $min' : '$after $min 30';
      case AfterPrayerIntervalType.hr1:
        return '$after $hour';

      default:
        return isEnglish ? '$after 15 $min' : '$after $min 15';
    }
  }
}

serviceFirstInterceptor(BuildContext context, bool value) async {
  if (!value) {
    await context.showAppDialog(
      AppDialog(
        title: AppLocale.serviceDisabled.getString(context),
        description: AppLocale.serviceDisabledDesc.getString(context),
      ),
    );
    return false;
  }
  return true;
}
