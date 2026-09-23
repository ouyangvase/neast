import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/common/widgets/merchant_detail_hero.dart';
import 'package:neast/features/common/widgets/merchant_info_card.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/providers/merchant_detail_provider.dart';
import 'package:neast/features/merchant/utils/merchant_map_actions.dart';
import 'package:neast/features/merchant/utils/merchant_share_actions.dart';
import 'package:neast/features/merchant/widgets/merchant_action_row.dart';
import 'package:neast/features/merchant/widgets/merchant_coupon_sheet.dart';
import 'package:neast/features/merchant/widgets/merchant_nearby_card.dart';
import 'package:neast/features/merchant/widgets/merchant_screen_skeleton.dart';

/// 商家详情页。
class MerchantScreen extends ConsumerStatefulWidget {
  const MerchantScreen({
    super.key,
    required this.merchantId,
  });

  final int merchantId;

  @override
  ConsumerState<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends ConsumerState<MerchantScreen> {
  @override
  void initState() {
    super.initState();
    _refreshDetail();
  }

  @override
  void didUpdateWidget(MerchantScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.merchantId != widget.merchantId) {
      _refreshDetail();
    }
  }

  void _refreshDetail() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(merchantDetailProvider(widget.merchantId).notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(merchantDetailProvider(widget.merchantId));

    return detailAsync.when(
      loading: () => const MerchantScreenSkeleton(),
      error: (_, __) => _MerchantErrorView(
        onRetry: _refreshDetail,
      ),
      data: (merchant) => _MerchantContent(
        merchant: merchant,
        merchantId: widget.merchantId,
      ),
    );
  }
}

class _MerchantErrorView extends StatelessWidget {
  const _MerchantErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: Column(
        children: [
          const MerchantDetailHero(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Failed to load merchant',
                    style: TextStyle(
                      fontSize: 15,
                      color: brandBlue.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onRetry,
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Go back',
                      style: TextStyle(
                        fontSize: 14,
                        color: brandBlue.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantContent extends ConsumerWidget {
  const _MerchantContent({
    required this.merchant,
    required this.merchantId,
  });

  final MerchantModel merchant;
  final int merchantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                MerchantDetailHero(
                  imageUrl: merchant.image,
                  onShareTap: () => shareMerchant(
                    merchantId: merchantId,
                    merchantName: merchant.name,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -50,
                  child: MerchantInfoCard(
                    merchantName: merchant.name,
                    distance: merchant.distanceLabel,
                    address: merchant.address,
                    imageUrl: merchant.image,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 72),
            MerchantActionRow(
              onRedeem: () => MerchantCouponSheet.show(
                context,
                merchantId: merchantId,
              ),
              onMap: () => openMerchantInGoogleMaps(
                address: merchant.address,
                latitude: merchant.latitude,
                longitude: merchant.longitude,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'How to Earn',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: brandBlue,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                'assets/images/merchant/how-to-earn.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 24),
            if (merchant.nearestMerchant != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Nearby Merchants',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: brandBlue,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: MerchantNearbyCard(
                  name: merchant.nearestMerchant!.name,
                  distance: merchant.nearestMerchant!.distanceLabel,
                  imageUrl: merchant.nearestMerchant!.image,
                  onTap: () => context.pushReplacement(
                    AppRoutes.merchantDetail(merchant.nearestMerchant!.id),
                  ),
                ),
              ),
            ] else
              const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
