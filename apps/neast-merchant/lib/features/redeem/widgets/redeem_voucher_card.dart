import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/redeem/models/redeem_voucher_preview_model.dart';
import 'package:neast/features/redeem/widgets/redeem_white_card.dart';

/// 优惠券信息卡（券名、商家、积分成本）。
class RedeemVoucherCard extends StatelessWidget {
  const RedeemVoucherCard({super.key, required this.preview});

  final RedeemVoucherPreviewModel preview;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return RedeemWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voucher',
            style: TextStyle(fontSize: 12, color: GivePointsColors.label),
          ),
          const SizedBox(height: 6),
          Text(
            preview.name,
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 500)],
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            preview.merchantLabel.isNotEmpty ? preview.merchantLabel : '-',
            style: const TextStyle(fontSize: 13, color: GivePointsColors.label),
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: brandBlue.withValues(alpha: 0.08)),
          const SizedBox(height: 14),
          const Text(
            'Points Cost',
            style: TextStyle(fontSize: 12, color: GivePointsColors.label),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                preview.pointsLabel,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'FD',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'pts',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: brandBlue.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
