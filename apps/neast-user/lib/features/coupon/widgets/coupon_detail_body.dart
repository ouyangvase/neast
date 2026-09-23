import 'package:flutter/material.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/widgets/coupon_detail_points_banner.dart';
import 'package:neast/features/coupon/widgets/coupon_detail_section.dart';

/// 优惠券详情内容区。
class CouponDetailBody extends StatelessWidget {
  const CouponDetailBody({
    super.key,
    required this.item,
  });

  final CouponListItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.voucherAmountLabel,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 700)],
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.detailSubtitle,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 500)],
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 10),
          CouponDetailPointsBanner(requiredPoints: item.requiredPoints),
          const SizedBox(height: 20),
          CouponDetailSection(
            title: 'Descriptions',
            body: item.detailDescription,
          ),
          const SizedBox(height: 20),
          CouponDetailSection(
            title: 'Valid Until',
            body: item.detailValidUntilLabel,
          ),
          if (item.detailTermsText.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            CouponDetailSection(
              title: 'Terms & Conditions',
              body: item.detailTermsText,
            ),
          ],
        ],
      ),
    );
  }
}
