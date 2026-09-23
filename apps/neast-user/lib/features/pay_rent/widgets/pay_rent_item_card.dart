import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/utils/rent_file_actions.dart';
// import 'package:neast/features/pay_rent/widgets/pay_rent_status_tag.dart';

/// Pay Rent 租金卡片（t_rent 列表项）。
class PayRentItemCard extends StatelessWidget {
  const PayRentItemCard({
    super.key,
    required this.rent,
    this.showPayButton = true,
  });

  final RentModel rent;
  final bool showPayButton;

  static const _landlordAvatarAsset = 'assets/icon/app_icon.png';
  static const _earnPointsColor = Color(0xFFD4A853);

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final expireLabel = formatRentExpireDate(rent.expireDate);
    final canPay = showPayButton && rent.canPay;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    _landlordAvatarAsset,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rent.hasLandlord) ...[
                        Text(
                          "Landlord's name:",
                          style: TextStyle(
                            fontSize: 12,
                            color: brandBlue.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rent.landlordName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: brandBlue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // PayRentStatusTag(rent: rent),
                    // if (rent.statusTag(context) != null) const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => openRentAgreementFile(context, rent),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tenancy Agreement',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: brandBlue,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: brandBlue.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: brandBlue.withValues(alpha: 0.08),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rent Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: brandBlue.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRentAmount(rent.amount),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: brandBlue,
                        ),
                      ),
                      if (expireLabel.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          expireLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: brandBlue.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  'You Earn ${rent.earnPoints} pts from this',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _earnPointsColor,
                  ),
                ),
              ],
            ),
          ),
          if (canPay) ...[
            Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: brandBlue.withValues(alpha: 0.08),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => context.push(
                    AppRoutes.payRentPayment,
                    extra: rent,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Pay Rent',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
