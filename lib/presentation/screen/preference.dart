import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: [
            Text(
              AppLocale.preference.getString(context),
              style: AppTypography.m3TitlelLarge(
                context,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.language_rounded,
              size: 15.sp,
              color: Theme.of(context).colorScheme.onSecondary,
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
                        style: AppTypography.m3TitlelMedium(
                          context,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
                                style: AppTypography.m3BodylLarge(
                                  context,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
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
              const ChangeLanguage(),
              SizedBox(height: 8.h),
              const ChangeTheme(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                AppLocale.theme.getString(context),
                style: AppTypography.m3BodylLarge(
                  context,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
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
                itemCount: PrayQuietThemeType.values.length,
                itemBuilder: (ctx, idx) {
                  final item = PrayQuietThemeType.values[idx];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 3.h,
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: SettingsItemContainer(
                        child: Row(
                          children: [
                            Icon(
                              Icons.style,
                              size: 13.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _buildThemeName(context, item.name),
                              style: AppTypography.m3BodylLarge(
                                context,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Radio.adaptive(
                              value: item.name,
                              groupValue: AdaptiveTheme.of(context).mode.name,
                              onChanged: (v) async {
                                if (v == 'light') {
                                  AdaptiveTheme.of(context).setLight();
                                  SystemChrome.setSystemUIOverlayStyle(
                                    const SystemUiOverlayStyle(
                                      systemNavigationBarColor:
                                          AppColors.carmyGreen,
                                    ),
                                  );
                                } else if (v == 'dark') {
                                  AdaptiveTheme.of(context).setDark();
                                  SystemChrome.setSystemUIOverlayStyle(
                                    const SystemUiOverlayStyle(
                                      systemNavigationBarColor:
                                          AppColors.carmyGreenDark,
                                    ),
                                  );
                                } else {
                                  AdaptiveTheme.of(context).setSystem();
                                  var brightness =
                                      MediaQuery.of(context).platformBrightness;
                                  bool isDarkMode =
                                      brightness == Brightness.dark;
                                  if (isDarkMode) {
                                    SystemChrome.setSystemUIOverlayStyle(
                                      const SystemUiOverlayStyle(
                                        systemNavigationBarColor:
                                            AppColors.carmyGreenDark,
                                      ),
                                    );
                                  } else {
                                    SystemChrome.setSystemUIOverlayStyle(
                                      const SystemUiOverlayStyle(
                                        systemNavigationBarColor:
                                            AppColors.carmyGreen,
                                      ),
                                    );
                                  }
                                }
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
    );
  }

  String _buildThemeName(BuildContext context, String name) {
    if (name == 'light') {
      return AppLocale.light.getString(context);
    } else if (name == 'dark') {
      return AppLocale.dark.getString(context);
    }
    return AppLocale.system.getString(context);
  }
}

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  context,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
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
                itemCount: PrayQuietLocaleType.values.length,
                itemBuilder: (ctx, idx) {
                  final item = PrayQuietLocaleType.values[idx];
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
                              groupValue:
                                  localization.currentLocale?.languageCode ??
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
    );
  }
}
