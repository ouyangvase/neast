import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/reward/models/reward_dashboard_model.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';
import 'package:neast/features/reward/widgets/reward_current_tier_card.dart';
import 'package:neast/features/reward/widgets/reward_tier_progress_list.dart';

/// 奖励等级详情页。
class RewardTierScreen extends ConsumerWidget {
  const RewardTierScreen({super.key});

  static const _contentTopRadius = 22.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final dashboardAsync = ref.watch(rewardDashboardProvider);

    final tier = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.tier,
      orElse: () => null,
    );
    final tiers = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.tiers,
      orElse: () => const <RewardTierItemModel>[],
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: brandBlueLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Tier Ranking',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 400)],
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                color: brandBlueLight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, _contentTopRadius + 10),
                  child: tier != null
                      ? RewardCurrentTierCard(tier: tier)
                      : const SizedBox(
                          height: 140,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -_contentTopRadius),
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_contentTopRadius),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: tiers.isEmpty
                      ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                      : RewardTierProgressList(
                          tiers: tiers,
                          currentTierId: tier?.current.id ?? 1,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
