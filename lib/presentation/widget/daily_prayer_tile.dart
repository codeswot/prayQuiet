import 'package:flutter/material.dart';
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

  bool get isCurrentPrayer => currentPrayer.startsWith(title);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isCurrentPrayer
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface.withOpacity(
                  0.4,
                ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isCurrentPrayer ? null : AppColors.secondary.withOpacity(0.2),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: isCurrentPrayer
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Text(title,
                style: AppTypography.m3BodylLarge(
                  context,
                  color: isCurrentPrayer
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                )),
            const Spacer(),
            Text(
              time ?? '--',
              style: AppTypography.m3BodylLarge(
                context,
                color: isCurrentPrayer
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
