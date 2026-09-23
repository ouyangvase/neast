import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/redeem/models/redeem_voucher_preview_model.dart';
import 'package:neast/features/redeem/widgets/redeem_white_card.dart';

/// 兑换详情卡（客户、联系方式、有效期）。
class RedeemDetailCard extends StatelessWidget {
  const RedeemDetailCard({super.key, required this.preview});

  final RedeemVoucherPreviewModel preview;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final rows = [
      ('Customer', preview.customerName.isNotEmpty ? preview.customerName : '-'),
      ('Contact', preview.contact.isNotEmpty ? preview.contact : '-'),
      ('Expiry', preview.expireAtLabel),
      ('Voucher Code', preview.sn.isNotEmpty ? preview.sn : '-'),
    ];

    return RedeemWhiteCard(
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(height: 24, color: brandBlue.withValues(alpha: 0.08)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    rows[i].$1,
                    style: const TextStyle(
                      fontSize: 12,
                      color: GivePointsColors.label,
                    ),
                  ),
                ),
                Text(
                  rows[i].$2,
                  style: TextStyle(fontSize: 12, color: brandBlue),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
