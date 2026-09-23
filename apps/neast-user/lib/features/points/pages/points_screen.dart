import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/home/providers/home_merchants_provider.dart';
import 'package:neast/features/home/widgets/home_section_header.dart';
import 'package:neast/features/points/providers/points_dashboard_provider.dart';
import 'package:neast/features/points/widgets/points_action_section.dart';
import 'package:neast/features/points/widgets/points_earn_section.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';
import 'package:neast/features/points/widgets/points_merchant_rewards_section.dart';
import 'package:neast/features/points/widgets/points_summary_card.dart';

/// 积分页主页面。
class PointsScreen extends ConsumerStatefulWidget {
  const PointsScreen({super.key});

  @override
  ConsumerState<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends ConsumerState<PointsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeAllMerchantsProvider.notifier).initialLoad();
      ref.read(pointsDashboardProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastBrandHeader(title: NeastBrandHeader.neastRichTitle('members')),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PointsSummaryCard(),
                  const SizedBox(height: 12),

                  const PointsActionSection(),
                  const SizedBox(height: 8),

                  const HomeSectionHeader(title: 'How to Earn Faster'),
                  const SizedBox(height: 12),
                  const PointsEarnSection(),
                  const SizedBox(height: 8),

                  const HomeSectionHeader(title: 'Merchant Reward'),
                  const SizedBox(height: 8),
                  const PointsMerchantRewardsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
