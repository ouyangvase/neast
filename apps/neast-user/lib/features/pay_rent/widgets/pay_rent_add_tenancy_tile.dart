import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_card_shadow.dart';

/// Pay Rent 主页底部「Add Tenancy」入口，点击跳转创建租金页。
class PayRentAddTenancyTile extends StatelessWidget {
  const PayRentAddTenancyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.payRentCreate),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: PayRentCardShadow.boxShadow,
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Add Tenancy',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: Colors.black,
                ),
              ),
            ),
            Image.asset(
              'assets/images/pay_rent/add-icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
