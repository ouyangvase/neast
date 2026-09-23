import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/utils/coupon_icon_utils.dart';
import 'package:neast/features/coupon/utils/coupon_redeem_actions.dart';
import 'package:neast/features/coupon/widgets/coupon_reward_card.dart';
import 'package:neast/features/coupon/widgets/coupon_screen_skeleton.dart';
import 'package:neast/features/merchant/providers/merchant_coupon_list_provider.dart';

/// 商家详情页优惠券底部弹窗。
class MerchantCouponSheet extends ConsumerStatefulWidget {
  const MerchantCouponSheet({
    super.key,
    required this.merchantId,
  });

  final int merchantId;

  static Future<void> show(
    BuildContext context, {
    required int merchantId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => MerchantCouponSheet(merchantId: merchantId),
    );
  }

  @override
  ConsumerState<MerchantCouponSheet> createState() =>
      _MerchantCouponSheetState();
}

class _MerchantCouponSheetState extends ConsumerState<MerchantCouponSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantCouponListProvider(widget.merchantId).notifier).open();
    });
  }

  Future<void> _onItemTap(CouponListItemModel item) async {
    switch (item.actionStatus) {
      case CouponActionStatus.useNow:
        showCouponQrcode(item);
      case CouponActionStatus.redeem:
        final updated = await redeemCoupon(ref, item);
        if (updated == null || !mounted) return;
        await ref
            .read(merchantCouponListProvider(widget.merchantId).notifier)
            .load(silent: true);
      case CouponActionStatus.fullyRedeemed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final listAsync = ref.watch(merchantCouponListProvider(widget.merchantId));
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: brandBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Vouchers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: listAsync.when(
                  loading: () => ListView.separated(
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const CouponRewardCardSkeleton(),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Failed to load vouchers',
                      style: TextStyle(
                        fontSize: 13,
                        color: brandBlue.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No vouchers available',
                          style: TextStyle(
                            fontSize: 13,
                            color: brandBlue.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final iconStyle = couponIconStyleFor(item.id);

                        return CouponRewardCard(
                          item: item,
                          icon: iconStyle.icon,
                          iconColor: iconStyle.color,
                          onTap: () => _onItemTap(item),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
