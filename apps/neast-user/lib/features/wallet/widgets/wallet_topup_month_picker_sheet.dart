import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/utils/wallet_topup_month_util.dart';

/// 充值记录月份选择（近 12 个自然月）。
Future<DateTime?> showWalletTopupMonthPicker(
  BuildContext context, {
  required DateTime selected,
  required List<DateTime> options,
}) {
  if (options.isEmpty) {
    return Future.value();
  }

  final brandBlue = context.appColors.brandBlue;

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Select month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  thickness: 1,
                  color: brandBlue.withValues(alpha: 0.08),
                ),
                itemBuilder: (context, index) {
                  final month = options[index];
                  final isSelected = month.year == selected.year &&
                      month.month == selected.month;
                  final label = formatWalletTopupMonthLabel(month);

                  return InkWell(
                    onTap: () => Navigator.of(sheetContext).pop(month),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? brandBlue
                                    : brandBlue.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              size: 20,
                              color: brandBlue,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
