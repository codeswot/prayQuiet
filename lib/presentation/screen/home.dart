import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/presentation/style/style.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      ref.watch(prayerProvider);
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () =>
                    ref.watch(prayerProvider.notifier).updatePrayer(),
                icon: Shimmer.fromColors(
                  baseColor: AppColors.text,
                  highlightColor: AppColors.secondary,
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.text,
                    size: 24,
                  ),
                ),
              )
            ],
            floating: true,
            pinned: true,
            snap: true,
            stretch: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.asset(
                    AppAssets.bg,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: AppColors.primary.withOpacity(0.4),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: CurrentPrayer(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const DailyPrayerList(),
            ),
          ),
          // SliverFillRemaining(
          //   hasScrollBody: false,
          //   fillOverscroll: true,
          //   child:
        ],
      );
    });
  }
}
