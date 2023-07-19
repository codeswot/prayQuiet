import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/domain/provider/setup.dart';

import 'package:pray_quiet/presentation/screen/screen.dart';
import 'package:pray_quiet/presentation/style/colors.dart';
// import 'package:workmanager/workmanager.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print('Text from background task');
//     return Future.value(true);
//   });
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerOneOffTask("pray-quiet", "dnd");
  final container = ProviderContainer();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const PrayQuietApp(),
  ));
}

class PrayQuietApp extends StatelessWidget {
  const PrayQuietApp({super.key});
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
                return const AppLayout();
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
                child: CircleAvatar(child: CircularProgressIndicator()),
              );
            },
          ),
        ));
  }
}
