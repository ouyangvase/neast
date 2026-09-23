import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/app_config/models/app_config_model.dart';
import 'package:neast/features/app_config/providers/app_config_provider.dart';
import 'package:neast/features/give_points/widgets/give_points_white_card.dart';
import 'package:neast/features/settlement/settlement_colors.dart';
import 'package:neast/features/settlement/settlement_constants.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';
import 'package:neast/features/wallet/widgets/fpx_bank_picker_sheet.dart';
import 'package:neast/features/wallet/widgets/fpx_bank_selector_hint.dart';

/// 支付页 — 支付方式选择卡片。
class SettlementPaymentMethodCard extends ConsumerWidget {
  const SettlementPaymentMethodCard({
    super.key,
    required this.amount,
    required this.selectedMethod,
    required this.onChanged,
    this.selectedFpxBankChannel,
    this.onFpxBankChanged,
  });

  final double amount;
  final SettlementPaymentMethod selectedMethod;
  final ValueChanged<SettlementPaymentMethod> onChanged;
  final String? selectedFpxBankChannel;
  final ValueChanged<String>? onFpxBankChanged;

  static final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'en_US');

  static const _methods = SettlementPaymentMethod.values;

  Future<void> _openFpxBankPicker(BuildContext context) async {
    if (onFpxBankChanged == null) return;

    if (selectedMethod != SettlementPaymentMethod.fpx) {
      onChanged(SettlementPaymentMethod.fpx);
    }

    final channel = await showFpxBankPickerSheet(
      context,
      selectedChannel: selectedFpxBankChannel,
    );
    if (channel != null) {
      onFpxBankChanged!(channel);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final fees = ref.watch(appConfigProvider).value?.paymentProcessingFees ??
        defaultPaymentProcessingFees;
    final balance = double.tryParse(
          ref.watch(merchantInfoProvider).value?.balance ?? '',
        ) ??
        0;
    final walletRemaining = _amountFormat.format(balance);
    final showFpxBankPicker = onFpxBankChanged != null;

    return GivePointsWhiteCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < _methods.length; i++) ...[
            _PaymentMethodTile(
              method: _methods[i],
              brandBlue: brandBlue,
              selected: selectedMethod == _methods[i],
              walletRemaining: walletRemaining,
              feeLabel: _methods[i] == SettlementPaymentMethod.wallet
                  ? null
                  : formatProcessingFeeLabel(fees[_methods[i].apiId] ?? 0),
              totalAmountLabel: _methods[i] == SettlementPaymentMethod.wallet
                  ? null
                  : formatTotalAmountWithFee(
                      amount,
                      fees[_methods[i].apiId] ?? 0,
                    ),
              onTap: () => onChanged(_methods[i]),
              fpxBankChannel: _methods[i] == SettlementPaymentMethod.fpx &&
                      showFpxBankPicker
                  ? selectedFpxBankChannel
                  : null,
              onFpxBankTap: _methods[i] == SettlementPaymentMethod.fpx &&
                      showFpxBankPicker
                  ? () => _openFpxBankPicker(context)
                  : null,
            ),
            if (i < _methods.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: brandBlue.withValues(alpha: 0.08),
              ),
          ],
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.brandBlue,
    required this.selected,
    required this.walletRemaining,
    this.feeLabel,
    this.totalAmountLabel,
    required this.onTap,
    this.fpxBankChannel,
    this.onFpxBankTap,
  });

  final SettlementPaymentMethod method;
  final Color brandBlue;
  final bool selected;
  final String walletRemaining;
  final String? feeLabel;
  final String? totalAmountLabel;
  final VoidCallback onTap;
  final String? fpxBankChannel;
  final VoidCallback? onFpxBankTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: _PaymentRadio(selected: selected, brandBlue: brandBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: brandBlue,
                      ),
                    ),
                    if (onFpxBankTap != null)
                      GestureDetector(
                        onTap: onFpxBankTap,
                        behavior: HitTestBehavior.opaque,
                        child: FpxBankSelectorHint(
                          selectedChannel: fpxBankChannel,
                        ),
                      ),
                  ],
                ),
              ),
              if (method == SettlementPaymentMethod.wallet)
                Text(
                  'Remaining: RM$walletRemaining',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SettlementColors.label,
                  ),
                )
              else if (feeLabel != null || totalAmountLabel != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (feeLabel != null)
                      Text(
                        feeLabel!,
                        style: TextStyle(
                          fontSize: 12,
                          color: brandBlue.withValues(alpha: 0.45),
                        ),
                      ),
                    if (totalAmountLabel != null) ...[
                      if (feeLabel != null) const SizedBox(height: 4),
                      Text(
                        totalAmountLabel!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: brandBlue.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentRadio extends StatelessWidget {
  const _PaymentRadio({
    required this.selected,
    required this.brandBlue,
  });

  final bool selected;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? brandBlue : brandBlue.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: brandBlue,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
