import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/refer/widgets/refer_referral_item.dart';

/// 推荐页 My Referrals 列表区域。
class ReferReferralsSection extends StatelessWidget {
  const ReferReferralsSection({super.key});

  static const _selectedMonth = 'Mar.';

  static const _referrals = [
    ReferReferralRecord(
      name: 'Sarah K.',
      initial: 'S',
      date: 'Mar 2026',
      points: '+1000 pts',
      status: ReferralStatus.pointsCredited,
    ),
    ReferReferralRecord(
      name: 'James L.',
      initial: 'J',
      date: 'Mar 2026',
      points: '+1000 pts',
      status: ReferralStatus.paidRent,
    ),
    ReferReferralRecord(
      name: 'Emily W.',
      initial: 'E',
      date: 'Feb 2026',
      points: null,
      status: ReferralStatus.pending,
    ),
    ReferReferralRecord(
      name: 'David M.',
      initial: 'D',
      date: 'Feb 2026',
      points: null,
      status: ReferralStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'My Referrals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: brandBlue,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: brandBlue.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedMonth,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: brandBlue.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._referrals.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReferReferralItem(item: item),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "That's all for now.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: brandBlue.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
