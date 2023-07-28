import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pray_quiet/domain/provider/prayer.dart';
import 'package:pray_quiet/presentation/widget/widget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      
      ref.watch(prayerProvider);
      return CustomScrollView(
        slivers: [
          SliverLayoutBuilder(
            builder: (BuildContext context, SliverConstraints constraints) {
              return const CustomSliverAppBar(
                title: 'Home',
                height: 300,
              );
            },
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
        ],
      );
    });
  }
}
