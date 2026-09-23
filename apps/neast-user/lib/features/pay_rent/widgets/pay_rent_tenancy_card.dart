import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_card_shadow.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_tenancy_sections.dart';

/// Pay Rent 主租约卡片：上段房产信息 + 分割线 + 下段租金金额与 Pay Now。
class PayRentTenancyCard extends StatelessWidget {
  const PayRentTenancyCard({super.key, required this.rent});

  final RentModel rent;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PayRentTenancyInfoSection(
            rent: rent,
            onTap: () => context.push(
              AppRoutes.payRentDetail,
              extra: rent,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: brandBlue.withValues(alpha: 0.08),
          ),
          PayRentAmountSection(rent: rent),
        ],
      ),
    );
  }
}
