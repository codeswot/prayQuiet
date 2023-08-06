import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
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

final FlutterLocalization localization = FlutterLocalization.instance;

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            IconButton(
              onPressed: () async {
                ref.watch(prayerProvider.notifier).updatePrayer();
              },
              icon: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.onSecondary,
                highlightColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.sp,
                ),
              ),
            )
          ],
          floating: true,
          pinned: true,
          snap: true,
          stretch: true,
          collapsedHeight: widget.height,
          title: widget.isHome
              ? const SizedBox()
              : Row(
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.m3TitlelLarge(
                        context,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.settings,
                      size: 15.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
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
                        height: widget.height * 2,
                      )
                    : const SizedBox(),
                Container(
                  height: widget.isHome ? widget.height * 2 : 150.h,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
                                      style: AppTypography.m3BodylMedium(
                                        context,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
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
