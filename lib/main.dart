import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/domain/provider/setup.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/screen/screen.dart';
import 'package:pray_quiet/presentation/style/colors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    systemNavigationBarColor: AppColors.carmyGreen,
                  ),
                );
                final setup = ref.watch(setupProvider);
                if (setup.isComplete) {
                  return const AppLayout();
                }

                if (setup.isInProgress) {
                  SystemChrome.setSystemUIOverlayStyle(
                    const SystemUiOverlayStyle(
                      systemNavigationBarColor: AppColors.introG,
                    ),
                  );
                }

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
