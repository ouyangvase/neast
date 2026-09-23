import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/models/receipt_confirm_payload.dart';
import 'package:neast/features/give_points/widgets/give_points_white_card.dart';

/// Confirm Points — 凭证摘要卡片。
class ConfirmPointsSummaryCard extends StatelessWidget {
  const ConfirmPointsSummaryCard({
    super.key,
    required this.payload,
  });

  final ReceiptConfirmPayload payload;

  static const _labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: GivePointsColors.formLabel,
  );

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: context.appColors.brandBlue,
    );

    return GivePointsWhiteCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Outlet',
            value: payload.outlet,
            labelStyle: _labelStyle,
            valueStyle: valueStyle,
          ),
          _divider,
          _SummaryRow(
            label: 'Receipt No',
            value: payload.receiptNumber,
            labelStyle: _labelStyle,
            valueStyle: valueStyle,
          ),
          _divider,
          _SummaryRow(
            label: 'Receipt Amount',
            value: 'RM ${payload.formattedAmount}',
            labelStyle: _labelStyle,
            valueStyle: valueStyle,
          ),
          _divider,
          _SummaryRow(
            label: 'Auto-Calculated',
            value: '${payload.autoPoints}pts',
            labelStyle: _labelStyle,
            valueStyle: valueStyle,
          ),
        ],
      ),
    );
  }

  static const _divider = Divider(
    height: 1,
    thickness: 1,
    color: Color(0xFFE8F0F8),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: valueStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
