import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/data/fpx_bank_config.dart';

/// FPX 行内银行选择提示。
class FpxBankSelectorHint extends StatelessWidget {
  const FpxBankSelectorHint({
    super.key,
    required this.selectedChannel,
  });

  final String? selectedChannel;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final bankName = FpxBankConfig.nameOf(selectedChannel);
    final hasSelection = bankName != null;
    final label = hasSelection ? bankName : 'Select Bank';

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: hasSelection ? FontWeight.w500 : FontWeight.w400,
              color: hasSelection
                  ? brandBlue.withValues(alpha: 0.75)
                  : brandBlue.withValues(alpha: 0.45),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: brandBlue.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
