import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 推荐记录状态。
enum ReferralStatus {
  pointsCredited,
  paidRent,
  pending,
}

/// 推荐记录列表项。
class ReferReferralRecord {
  const ReferReferralRecord({
    required this.name,
    required this.initial,
    required this.date,
    required this.points,
    required this.status,
  });

  final String name;
  final String initial;
  final String date;
  final String? points;
  final ReferralStatus status;
}

/// 推荐页单条推荐记录。
class ReferReferralItem extends StatelessWidget {
  const ReferReferralItem({
    super.key,
    required this.item,
  });

  final ReferReferralRecord item;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: brandBlue,
              shape: BoxShape.circle,
            ),
            child: Text(
              item.initial,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.date,
                  style: TextStyle(
                    fontSize: 11,
                    color: brandBlue.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.points != null)
                Text(
                  item.points!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
              const SizedBox(height: 4),
              _StatusBadge(status: item.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ReferralStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReferralStatus.pointsCredited => (
          'Points Credited',
          const Color(0xFF3EBF7A),
        ),
      ReferralStatus.paidRent => (
          'Paid Rent',
          const Color(0xFF8B5CF6),
        ),
      ReferralStatus.pending => (
          'Pending',
          const Color(0xFF9CA3AF),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
