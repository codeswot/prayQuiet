// ignore_for_file: depend_on_referenced_packages

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/domain/provider/setup.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/screen/screen.dart';
import 'package:pray_quiet/presentation/style/colors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@pragma('vm:entry-point')
void test() {
  final LoggingService logger = LoggingService();
  final now = DateTime.now();

  logger.debug('I got called at ${now.toIso8601String()}');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize services
  NotificationService().initializeNotifications();
  await AndroidAlarmManager.initialize();

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
              bodyMedium: TextStyle(fontSize: 25.sp),
            ),
            fontFamily: 'Nunito',
          ),
          home: Material(
            child: Consumer(
              builder: (context, ref, _) {
                final setup = ref.watch(setupProvider);
                if (setup.isComplete) {
                  return const Home();
                }
                if (setup.isNotStarted) {
                  return Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 500),
                        delay: Duration(milliseconds: 800),
                      )
                    ],
                    child: const Introduction(),
                  );
                }
                return const Center(
                  child: CircleAvatar(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
