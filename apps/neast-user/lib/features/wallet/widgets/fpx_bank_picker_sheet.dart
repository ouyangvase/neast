import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/data/fpx_bank_config.dart';

/// FPX 银行选择底部弹窗。
Future<String?> showFpxBankPickerSheet(
  BuildContext context, {
  String? selectedChannel,
}) {
  final brandBlue = context.appColors.brandBlue;
  final banks = FpxBankConfig.items;

  return showModalBottomSheet<String>(
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
                'Select Bank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.55,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: banks.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  thickness: 1,
                  color: brandBlue.withValues(alpha: 0.08),
                ),
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  final isSelected = bank.channel == selectedChannel;

                  return InkWell(
                    onTap: () => Navigator.of(sheetContext).pop(bank.channel),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              bank.name,
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
