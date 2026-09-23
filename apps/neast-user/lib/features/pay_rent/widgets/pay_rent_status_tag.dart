import 'package:flutter/material.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/utils/rent_file_actions.dart';

/// 租金卡片状态 tag（仅待审核 / 待绑定 / 审核驳回）。
class PayRentStatusTag extends StatelessWidget {
  const PayRentStatusTag({super.key, required this.rent});

  final RentModel rent;

  @override
  Widget build(BuildContext context) {
    final tag = rent.statusTag(context);
    if (tag == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tag.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tag.label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: tag.color,
        ),
      ),
    );
  }
}
