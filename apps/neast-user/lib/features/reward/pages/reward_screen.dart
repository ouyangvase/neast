import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/common/widgets/guest_login_placeholder.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';
import 'package:neast/features/reward/widgets/reward_featured_section.dart';
import 'package:neast/features/reward/widgets/reward_my_points_card.dart';
import 'package:neast/features/reward/widgets/reward_nearby_section.dart';
import 'package:neast/features/reward/widgets/reward_tier_progress_card.dart';

/// Reward Tab 主页面。
class RewardScreen extends ConsumerWidget {
  const RewardScreen({super.key});

  static const _contentTopRadius = 22.0;

  Future<void> _onRefresh(WidgetRef ref) async {
    await ref.read(rewardDashboardProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: brandBlueLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Reward',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 400)],
              color: Colors.white,
            ),
          ),
        ),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: brandBlueLight,
          onRefresh: () => _onRefresh(ref),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ColoredBox(
                  color: brandBlueLight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      _contentTopRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 5),
                        if (isLoggedIn) ...[
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.points),
                            behavior: HitTestBehavior.opaque,
                            child: const RewardMyPointsCard(),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.rewardTier),
                            behavior: HitTestBehavior.opaque,
                            child: const RewardTierProgressCard(),
                          ),
                        ] else ...[
                          const GuestLoginPlaceholder(
                            style: GuestLoginPlaceholderStyle.card,
                            message: 'Log in to view your points and tier',
                          ),
                        ],
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -_contentTopRadius),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(_contentTopRadius),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RewardFeaturedSection(),
                        SizedBox(height: 20),
                        RewardNearbySection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
