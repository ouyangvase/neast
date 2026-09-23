import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/utils/rent_file_actions.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_status_tag.dart';

/// 租约卡片上段：房产名 / 房东 / 租期。
class PayRentTenancyInfoSection extends StatelessWidget {
  const PayRentTenancyInfoSection({
    super.key,
    required this.rent,
    this.showChevron = true,
    this.onTap,
  });

  final RentModel rent;
  final bool showChevron;
  final VoidCallback? onTap;

  static const _subtitleColor = Color(0xFF999999);

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final leasePeriod = rent.displayLeasePeriod;

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        rent.displayPropertyTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 500)],
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (rent.statusTag(context) != null) ...[
                      const SizedBox(width: 8),
                      PayRentStatusTag(rent: rent),
                    ],
                  ],
                ),
                if (rent.displayLandlordName.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${rent.displayLandlordName} · ${rent.ownerPathLabel}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _subtitleColor,
                    ),
                  ),
                ],
                if (rent.inviteSent || rent.isHeldPayout) ...[
                  const SizedBox(height: 4),
                  Text(
                    rent.inviteSent
                        ? 'Invite sent · Held by NEAST'
                        : 'Held by NEAST',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
                if (rent.isPayoutQueued) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Payout queued · ${rent.destinationBankLabel}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF12641C),
                    ),
                  ),
                ],
                if (leasePeriod.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    leasePeriod,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showChevron)
            Icon(
              Icons.chevron_right,
              size: 20,
              color: brandBlue.withValues(alpha: 0.6),
            ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

/// 租约卡片下段：租金金额 / 到期提示 / Pay Now。
class PayRentAmountSection extends StatelessWidget {
  const PayRentAmountSection({
    super.key,
    required this.rent,
    this.showPayButton = true,
  });

  final RentModel rent;
  final bool showPayButton;

  static const _subtitleColor = Color(0xFF999999);

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final dueText = rent.displayDueText;
    final canPay = showPayButton && rent.canPay;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Rental Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                formatRentAmount(rent.amount),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
            ],
          ),
          if (dueText.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              dueText,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 400)],
                color: _subtitleColor,
              ),
            ),
          ],
          if (canPay) ...[
            const SizedBox(height: 14),
            SizedBox(
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
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
