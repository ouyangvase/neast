import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';

/// Pay Rent 历史记录单条列表项。
class PayRentHistoryTile extends StatelessWidget {
  const PayRentHistoryTile({
    super.key,
    required this.item,
    this.compact = false,
    this.showDivider = true,
    this.showStatus = false,
    this.onTap,
  });

  final RentHistoryModel item;
  final bool compact;
  final bool showDivider;
  final bool showStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    if (compact) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                item.displayDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: Colors.black,
                ),
              ),
            ),
            if (showStatus)
              Expanded(
                flex: 3,
                child: Text(
                  _statusLabel(item.payStatus),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: _statusColor(item.payStatus),
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Text(
                item.displayAmount,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 600)],
                  color: brandBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    }

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.displayDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              if (showStatus) ...[
                const SizedBox(width: 8),
                Text(
                  _statusLabel(item.payStatus),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _statusColor(item.payStatus),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                item.displayAmount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: brandBlue.withValues(alpha: 0.08),
          ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: showDivider
            ? null
            : const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
        child: content,
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'late':
      case 'overdue':
        return 'Late';
      case 'on_time':
      case 'paid':
      case 'settled':
        return 'Paid on time';
      default:
        return 'Pending';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'late':
      case 'overdue':
        return const Color(0xFFFF4444);
      case 'on_time':
      case 'paid':
      case 'settled':
        return const Color(0xFF2EAF7D);
      default:
        return const Color(0xFFD4A853);
    }
  }
}
