import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/home/providers/home_merchants_provider.dart';
import 'package:neast/features/points/widgets/points_merchant_reward_card.dart';

/// 积分页 Merchant Reward 网格区块。
class PointsMerchantRewardsSection extends ConsumerWidget {
  const PointsMerchantRewardsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeAllMerchantsProvider);
    final notifier = ref.read(homeAllMerchantsProvider.notifier);

    if (notifier.locationUnavailable) {
      return const _EmptyHint(message: 'Enable location to see nearby merchants');
    }

    if (state.isLoading && state.list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (state.list.isEmpty) {
      return const _EmptyHint(message: 'No nearby merchants');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 200,
      ),
      itemCount: state.list.length,
      itemBuilder: (context, index) {
        final merchant = state.list[index];
        return Align(
          alignment: Alignment.topCenter,
          child: PointsMerchantRewardCard(
            merchant: merchant,
            onTap: () => context.push(AppRoutes.merchantDetail(merchant.id)),
          ),
        );
      },
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final mutedBlue = context.appColors.brandBlue.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 13, color: mutedBlue),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
