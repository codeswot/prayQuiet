import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:pray_quiet/presentation/style/style.dart';

class IntroductionIndicator extends StatelessWidget {
  const IntroductionIndicator(this.isActive, {Key? key}) : super(key: key);
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.text : AppColors.text.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}

class IntroductionPage extends StatelessWidget {
  const IntroductionPage(this.intro, {super.key});
  final IntroductionModel intro;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          intro.image,
          repeat: false,
        ),
        const SizedBox(height: 32),
        Text(
          intro.title,
          style: AppTypography.m3TitlelLarge(),
          textAlign: TextAlign.center,
        ).animate().fadeIn(),
        const SizedBox(height: 16),
        Text(
          intro.description,
          style: AppTypography.m3BodylLarge(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class IntroductionModel {
  final String title;
  final String description;
  final String image;
  final Color color;

  IntroductionModel({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}
