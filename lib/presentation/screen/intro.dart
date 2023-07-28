import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pray_quiet/presentation/shared/context_extension.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class Introduction extends ConsumerStatefulWidget {
  const Introduction({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroductionState();
}

class _IntroductionState extends ConsumerState<Introduction> {
  final List<IntroductionModel> _intros = <IntroductionModel>[
    IntroductionModel(
      title: 'Assalamualaikum\n🤝',
      description: 'Welcome to Pray Quiet, the app that helps you pray on time',
      image: AppAssets.intro1,
      color: AppColors.primary,
    ),
    IntroductionModel(
      title: 'Prayer on time\n🕋',
      description:
          'with Pray Quiet, you can get notified when it\'s time to pray',
      image: AppAssets.intro2,
      color: AppColors.secondary,
    ),
    IntroductionModel(
      title: 'Pray Quiet\n🤫',
      description:
          'Pray Quiet automatically puts your phone on silence,Pray without distractions',
      image: AppAssets.intro3,
      color: AppColors.tertiary,
    ),
  ];
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: _intros.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final intro = _intros[index];
              return Container(
                padding: const EdgeInsets.all(16),
                color: _intros[index].color.withOpacity(0.3),
                child: IntroductionPage(intro),
              );
            },
            onPageChanged: (index) {
              if (index == 0) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    systemNavigationBarColor: AppColors.introG,
                  ),
                );
              } else if (index == 1) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    systemNavigationBarColor: AppColors.introP,
                  ),
                );
              } else if (index == 2) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    systemNavigationBarColor: AppColors.introW,
                  ),
                );
              }

              setState(() {
                currentIndex = index;
              });
            },
          ),
          // Positioned(
          //   right: 0,
          //   child: SafeArea(
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: IconButton.filledTonal(
          //         tooltip: 'Language',
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.language_outlined,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 32,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      'previous',
                      style: AppTypography.m3BodylLarge(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _intros
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IntroductionIndicator(
                              _intros.indexOf(e) == currentIndex,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  TextButton(
                    onPressed: () {
                      if (currentIndex == _intros.length - 1) {
                        SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                            systemNavigationBarColor: AppColors.pG,
                          ),
                        );
                        context.push(const PermissionScreen());
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text(
                      'Next',
                      style: AppTypography.m3BodylLarge(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
