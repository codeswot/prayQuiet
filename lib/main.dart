import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/app_locale.dart';
import 'package:pray_quiet/domain/provider/setup.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/screen/screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pray_quiet/presentation/style/style.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize services
  NotificationService().initializeNotifications();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  runApp(
    const ProviderScope(
      child: PrayQuietApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class PrayQuietApp extends StatefulWidget {
  const PrayQuietApp({Key? key}) : super(key: key);

  @override
  State<PrayQuietApp> createState() => _PrayQuietAppState();
}

class _PrayQuietAppState extends State<PrayQuietApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ha', AppLocale.HA),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

// the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AdaptiveTheme(
            initial: AdaptiveThemeMode.light,
            light: lightTheme,
            dark: darkTheme,
            builder: (light, dark) {
              return MaterialApp(
                title: 'PrayQuiet',
                debugShowCheckedModeBanner: false,
                supportedLocales: localization.supportedLocales,
                localizationsDelegates: localization.localizationsDelegates,
                theme: light,
                darkTheme: dark,
                home: Material(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final setup = ref.watch(setupProvider);
                      if (setup.isComplete) {
                        return const AppLayout();
                      }

                      // if (setup.isInProgress) {
                      //   SystemChrome.setSystemUIOverlayStyle(
                      //     const SystemUiOverlayStyle(
                      //       systemNavigationBarColor: AppColors.introG,
                      //     ),
                      //   );
                      // }

                      return Animate(
                        effects: const [
                          FadeEffect(
                            duration: Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 90),
                          )
                        ],
                        child: const Introduction(),
                      );
                    },
                  ),
                ),
              );
            });
      },
    );
  }
}
