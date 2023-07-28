import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({
    super.key,
    this.isHome = true,
    required this.title,
    this.height = 230,
  });
  final bool isHome;
  final String title;
  final double height;

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return SliverAppBar(
          actions: [
            IconButton(
              onPressed: () async {
                ref.watch(prayerProvider.notifier).updatePrayer();
              },
              icon: Shimmer.fromColors(
                baseColor: AppColors.text,
                highlightColor: AppColors.secondary,
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.text,
                  size: 24.sp,
                ),
              ),
            )
          ],
          floating: true,
          pinned: true,
          snap: true,
          stretch: true,
          title: widget.isHome
              ? const SizedBox()
              : Row(
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.m3TitlelLarge(),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.settings,
                      size: 15.sp,
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                  ],
                ),
          expandedHeight: widget.height.h,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                widget.isHome
                    ? Image.asset(
                        AppAssets.bg,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300.h,
                      )
                    : const SizedBox(),
                Container(
                  height: widget.isHome ? 300.h : 150.h,
                  color: AppColors.primary.withOpacity(0.4),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: widget.isHome ? 32.h : 16.h,
                  ),
                  child: widget.isHome
                      ? const CurrentPrayer()
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: FutureBuilder<PackageInfo>(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'V ${snapshot.data?.version}(${snapshot.data?.buildNumber})',
                                      style: AppTypography.m3BodylMedium(),
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
