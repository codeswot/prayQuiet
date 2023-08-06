import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/app_locale.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class Preference extends StatefulWidget {
  const Preference({Key? key}) : super(key: key);

  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary.withOpacity(0.4),
        title: Row(
          children: [
            Text(
              AppLocale.preference.getString(context),
              style: AppTypography.m3TitlelLarge(),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.language_rounded,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: SettingsItemContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PrayQuiet ©',
                        style: AppTypography.m3TitlelMedium(),
                      ),
                      SizedBox(height: 8.h),
                      SettingsItemContainer(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocale.appDescription.getString(context),
                                style: AppTypography.m3BodylLarge(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: SettingsItemContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Animate(
                        effects: const [
                          FadeEffect(),
                        ],
                        child: Text(
                          AppLocale.language.getString(context),
                          style: AppTypography.m3BodylLarge(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      const SettingsDivider(),
                      SizedBox(height: 4.h),
                      Animate(
                        effects: const [
                          FadeEffect(),
                        ],
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: PrayQuietLocal.values.length,
                          itemBuilder: (ctx, idx) {
                            final item = PrayQuietLocal.values[idx];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: GestureDetector(
                                onTap: () {
                                  localization.translate(item.name);
                                },
                                child: SettingsItemContainer(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.language_rounded,
                                        size: 13.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        localization.getLanguageName(
                                                  languageCode: item.name,
                                                ) ==
                                                'هَوُسَ'
                                            ? 'Hausa'
                                            : localization.getLanguageName(
                                                languageCode: item.name,
                                              ),
                                      ),
                                      const Spacer(),
                                      Radio.adaptive(
                                        value: item.name,
                                        groupValue: localization
                                                .currentLocale?.languageCode ??
                                            'en',
                                        onChanged: (v) async {
                                          localization.translate(item.name);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
