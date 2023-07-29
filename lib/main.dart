import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/position.dart';
import 'package:pray_quiet/domain/provider/setup.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/screen/screen.dart';
import 'package:pray_quiet/presentation/style/colors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void bgServe() async {
  final LoggingService logger = LoggingService();
  SharedPreferences pref = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final g = await LocationService.determinePosition();

  Position pos = Position(lat: g.latitude, lng: g.longitude, mock: false);

  pref.setString('position', pos.toRawJson());

  logger.debug('I got called at ${now.toIso8601String()}');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize services
  NotificationService().initializeNotifications();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  AndroidAlarmManager.periodic(
    const Duration(hours: 10),
    3,
    bgServe,
    rescheduleOnReboot: true,
    allowWhileIdle: true,
    exact: true,
    wakeup: false,
  );

  runApp(
    const ProviderScope(
      child: PrayQuietApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class PrayQuietApp extends StatelessWidget {
  const PrayQuietApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'PrayQuiet',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
            ),
            useMaterial3: true,
            textTheme: TextTheme(
              labelLarge: TextStyle(fontSize: 15.sp),
              bodyMedium: TextStyle(fontSize: 14.sp),
            ),
            fontFamily: 'Nunito',
          ),
          home: Material(
            child: Consumer(
              builder: (context, ref, _) {
                final setup = ref.watch(setupProvider);
                if (setup.isComplete) {
                  SystemChrome.setSystemUIOverlayStyle(
                    const SystemUiOverlayStyle(
                      systemNavigationBarColor: AppColors.carmyGreen,
                    ),
                  );
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
                      delay: Duration(milliseconds: 100),
                    )
                  ],
                  child: const Introduction(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
