import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:pray_quiet/data/app_locale.dart';
import 'package:pray_quiet/presentation/screen/screen.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          Home(),
          // Qiblah(),
          Settings(),
          // Notifications(),
        ],
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: AppLocale.home.getString(context),
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.navigation),
          //   label: 'Qiblah',
          // ),
          // NavigationDestination(
          //   icon: Icon(Icons.notifications),
          //   label: 'Notifications',
          // ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: AppLocale.settings.getString(context),
          ),
        ],
      ),
    );
  }
}
