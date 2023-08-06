import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/app_locale.dart';

import 'package:pray_quiet/presentation/shared/context_extension.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class Introduction extends ConsumerStatefulWidget {
  const Introduction({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroductionState();
}

class _IntroductionState extends ConsumerState<Introduction> {
  @override
  void initState() {
    super.initState();
  }

  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<IntroductionModel> intros = <IntroductionModel>[
      IntroductionModel(
        title: AppLocale.intro1Title.getString(context),
        description: AppLocale.intro1Desc.getString(context),
        image: AppAssets.intro1,
        color: AppColors.primary,
      ),
      IntroductionModel(
        title: AppLocale.intro2Title.getString(context),
        description: AppLocale.intro2Desc.getString(context),
        image: AppAssets.intro2,
        color: AppColors.secondary,
      ),
      IntroductionModel(
        title: AppLocale.intro3Title.getString(context),
        description: AppLocale.intro3Desc.getString(context),
        image: AppAssets.intro3,
        color: AppColors.tertiary,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: intros.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final intro = intros[index];
              return Container(
                padding: const EdgeInsets.all(16),
                color: intros[index].color.withOpacity(0.3),
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
          Positioned(
            right: 0,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PopupMenuButton<String>(
                    tooltip: AppLocale.language.getString(context),
                    initialValue:
                        localization.currentLocale?.languageCode ?? 'en',
                    onSelected: (v) {
                      localization.translate(v);
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'en',
                          child: Text(
                            'English',
                            style: AppTypography.m3BodylLarge(
                              context,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'ha',
                          child: Text(
                            'Hausa',
                            style: AppTypography.m3BodylLarge(
                              context,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ];
                    },
                    icon: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.text.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.language_outlined,
                        color: AppColors.pG,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                      AppLocale.previous.getString(context),
                      style: AppTypography.m3BodylLarge(
                        context,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: intros
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IntroductionIndicator(
                              intros.indexOf(e) == currentIndex,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  TextButton(
                    onPressed: () {
                      if (currentIndex == intros.length - 1) {
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
                      AppLocale.next.getString(context),
                      style: AppTypography.m3BodylLarge(
                        context,
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
