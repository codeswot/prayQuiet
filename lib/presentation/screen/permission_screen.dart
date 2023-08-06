import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/data/app_locale.dart';

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
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.pG,
        ),
      );
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
                  AppLocale.oneMoreThing.getString(context),
                  textAlign: TextAlign.center,
                  style: AppTypography.m3TitlelMedium(context,),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocale.inOtherTo.getString(context),
                  textAlign: TextAlign.center,
                  style: AppTypography.m3BodylLarge(
                  context,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 30.h),
                const PermissionsListView(),
                SizedBox(height: 20.h),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(AppLocale.permissionInfo.getString(context),
                      textAlign: TextAlign.center,
                      style: AppTypography.m3BodylLarge(
                      context,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
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
                                        title: AppLocale.setupFailed
                                            .getString(context),
                                        description: AppLocale
                                            .serviceDisabledDesc
                                            .getString(context),
                                        onTap: () async {
                                          await LocationService
                                              .openLocationSettings();
                                        },
                                      ),
                                    );
                                  }
                                }

                                await ref
                                    .watch(setupProvider.notifier)
                                    .attemptSetup();

                                if (ref.watch(setupProvider).isComplete) {
                                  if (context.mounted) {
                                    context.pop();
                                  }
                                }
                              },
                        child: isLoading
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: AppColors.text.withOpacity(0.6),
                                  strokeWidth: 8,
                                ),
                              )
                            : Text(AppLocale.grantAccess.getString(context)),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    systemNavigationBarColor: AppColors.introW,
                                  ),
                                );
                                context.pop();
                              },
                        child: Text(AppLocale.notNow.getString(context)),
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.do_disturb_alt_outlined,
          ),
          title: Text(
            'Do not disturb',
            style: AppTypography.m3BodylLarge(
             context,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
          subtitle: Text(
            AppLocale.dndDesc.getString(context),
            style: AppTypography.m3BodylLarge(
             context,
              fontWeight: FontWeight.w500,
              fontSize: 9.sp,
            ),
          ),
        ),
        Divider(height: 3.h),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.location_on_outlined,
          ),
          title: Text(
            'Location',
            style: AppTypography.m3BodylLarge(
             context,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
          subtitle: Text(
            AppLocale.locDesc.getString(context),
            style: AppTypography.m3BodylLarge(
             context,
              fontWeight: FontWeight.w500,
              fontSize: 9.sp,
            ),
          ),
        ),
        Divider(height: 3.h),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.notifications_outlined,
          ),
          title: Text(
            'Notifications',
            style: AppTypography.m3BodylLarge(
             context,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
          subtitle: Text(
           AppLocale.notiDesc.getString(context),
            style: AppTypography.m3BodylLarge(
             context,
              fontWeight: FontWeight.w500,
              fontSize: 9.sp,
            ),
          ),
        ),
        Divider(height: 3.h),
      ],
    );
  }
}
