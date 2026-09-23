import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';
import 'package:neast/features/home/widgets/deal_card.dart';
import 'package:neast/features/home/widgets/home_merchant_section_skeleton.dart';
import 'package:neast/features/home/widgets/home_section_header.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

/// 首页「Nearby Deals」区块。
class NearbyDealsSection extends ConsumerWidget {
  const NearbyDealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDashboard = ref.watch(homeDashboardProvider);
    final notifier = ref.read(homeDashboardProvider.notifier);

    if (notifier.locationUnavailable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(
            title: 'Nearby Deals',
            onTrailingTap: () => _openList(context),
          ),
          const SizedBox(height: 12),
          const _EmptyHint(
            message: 'Enable location to see nearby merchants',
          ),
        ],
      );
    }

    return asyncDashboard.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(
            title: 'Nearby Deals',
            onTrailingTap: () => _openList(context),
          ),
          const SizedBox(height: 12),
          const HomeDealCardsSkeleton(),
        ],
      ),
      error: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(
            title: 'Nearby Deals',
            onTrailingTap: () => _openList(context),
          ),
          const SizedBox(height: 12),
          const _EmptyHint(message: 'Failed to load nearby merchants'),
        ],
      ),
      data: (dashboard) {
        final merchants = dashboard.nearbyDeals;
        if (merchants.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSectionHeader(
                title: 'Nearby Deals',
                onTrailingTap: () => _openList(context),
              ),
              const SizedBox(height: 12),
              const _EmptyHint(message: 'No nearby merchants'),
            ],
          );
        }

        return _buildContent(context, merchants);
      },
    );
  }

  void _openList(BuildContext context) {
    context.push(AppRoutes.merchantMapRoute());
  }

  Widget _buildContent(BuildContext context, List<MerchantModel> merchants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'Nearby Deals',
          onTrailingTap: () => _openList(context),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: DealCard.listItemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: merchants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return DealCard(
                merchant: merchant,
                onTap: () => context.push(AppRoutes.merchantDetail(merchant.id)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final mutedBlue = context.appColors.brandBlue.withValues(alpha: 0.5);

    return SizedBox(
      height: DealCard.listItemHeight,
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
