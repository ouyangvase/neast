import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/models/wallet_topup_model.dart';

/// 充值记录列表区块。
class WalletTopupRecordSection extends StatelessWidget {
  const WalletTopupRecordSection({
    super.key,
    required this.records,
    required this.month,
    this.isLoading = false,
    this.hasMore = false,
  });

  final List<WalletTopupModel> records;
  final String month;
  final bool isLoading;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Topup record',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: brandBlue,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: brandBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: records.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      isLoading ? 'Loading...' : 'No topup records',
                      style: TextStyle(
                        fontSize: 13,
                        color: brandBlue.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < records.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: brandBlue.withValues(alpha: 0.08),
                          indent: 16,
                          endIndent: 16,
                        ),
                      _RecordTile(record: records[i], brandBlue: brandBlue),
                    ],
                    if (!hasMore && records.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "That's all for now.",
                          style: TextStyle(
                            fontSize: 13,
                            color: brandBlue.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.record,
    required this.brandBlue,
  });

  final WalletTopupModel record;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    final amountText = '+RM${record.amountValue.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top-up amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.displayDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: brandBlue.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}
