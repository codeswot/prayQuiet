import 'package:flutter/material.dart';
import 'package:pray_quiet/domain/service/date.dart';

import 'package:pray_quiet/presentation/style/style.dart';

class DailyPrayerTile extends StatelessWidget {
  const DailyPrayerTile({
    required this.title,
    required this.time,
    required this.currentPrayer,
    super.key,
  });
  final String title;
  final String? time;
  final String currentPrayer;

  bool get isCurrentPrayer => title == currentPrayer;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isCurrentPrayer
            ? AppColors.primary
            : AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
          ),
          const SizedBox(width: 16),
          Text(title, style: AppTypography.m3BodylLarge()),
          const Spacer(),
          Text(
            DateService.fmt12Hr(time ?? '') ?? '--:--',
            style: AppTypography.m3BodylLarge(),
          ),
        ],
      ),
    );
  }
}
