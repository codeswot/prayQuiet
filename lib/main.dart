import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/domain/provider/setup.dart';
import 'package:pray_quiet/domain/service/service.dart';
import 'package:pray_quiet/presentation/screen/screen.dart';
import 'package:pray_quiet/presentation/style/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  NotificationService().initializeNotifications();
  await AndroidAlarmManager.initialize();

  runApp(
    const ProviderScope(
      child: PrayQuietApp(),
    ),
  );
}

class PrayQuietApp extends StatelessWidget {
  const PrayQuietApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrayQuiet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        useMaterial3: true,
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
  }
}
