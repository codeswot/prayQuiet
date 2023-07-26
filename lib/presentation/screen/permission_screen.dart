import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/domain/provider/setup.dart';
import 'package:pray_quiet/domain/service/service.dart';

import 'package:pray_quiet/presentation/shared/shared.dart';

import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/dialog.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.5),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'one more thing... ',
                  textAlign: TextAlign.center,
                  style: AppTypography.m3TitlelMedium(),
                ),
                const SizedBox(height: 16),
                Text(
                  'in order to do a great job, Pray Quiet needs you to grant  permission to these things, ',
                  textAlign: TextAlign.center,
                  style: AppTypography.m3BodylLarge(
                    color: AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 36),
                const PermissionsListView(),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      'on tapping the "Grant Access" button the app will open the Do not disturb settings page for you, scroll and find Pray Quiet then toggle it on "Allow Do not disturb access" ',
                      textAlign: TextAlign.center,
                      style: AppTypography.m3BodylLarge(
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                const Spacer(),
                const SizedBox(height: 36),
                Consumer(builder: (context, ref, _) {
                  final isLoading =
                      ref.watch(setupProvider) == SetupState.inProgress;

                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                bool isavailable =
                                    await LocationService.isServiceAvailable();

                                if (context.mounted) {
                                  if (!isavailable) {
                                    return context.showAppDialog(
                                      AppDialog(
                                        title: 'Setup Failed',
                                        description:
                                            'Seems your location is turned off, please enable location and make sure you have internet connection, then try again !',
                                        onTap: () async {
                                          await LocationService
                                              .openLocationSettings();
                                        },
                                      ),
                                    );
                                  }
                                }

                                await ref
                                    .read(setupProvider.notifier)
                                    .attemptSetup();

                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: AppColors.text,
                                  strokeWidth: 8,
                                ),
                              )
                            : const Text('Grant Access'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: isLoading ? null : () => context.pop(),
                        child: const Text('Not now'),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class PermissionsListView extends StatelessWidget {
  const PermissionsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.do_disturb_alt_outlined,
          ),
          title: Text(
            'Do not disturb',
            style: AppTypography.m3BodylLarge(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'To automatically put your phone on silent during prayer times',
            style: AppTypography.m3BodylLarge(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.location_on_outlined,
          ),
          title: Text(
            'Location',
            style: AppTypography.m3BodylLarge(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'To get prayer times for your location',
            style: AppTypography.m3BodylLarge(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.notifications_outlined,
          ),
          title: Text(
            'Notifications',
            style: AppTypography.m3BodylLarge(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'To notify you when it\'s time to pray',
            style: AppTypography.m3BodylLarge(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
