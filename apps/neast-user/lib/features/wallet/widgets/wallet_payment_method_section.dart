import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';
import 'package:neast/features/wallet/models/payment_quote_model.dart';
import 'package:neast/features/wallet/providers/payment_quote_provider.dart';
import 'package:neast/features/wallet/providers/wallet_balance_provider.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';
import 'package:neast/features/wallet/widgets/fpx_bank_picker_sheet.dart';
import 'package:neast/features/wallet/widgets/fpx_bank_selector_hint.dart';

/// 付款页支付方式选择区块。
class WalletPaymentMethodSection extends ConsumerStatefulWidget {
  const WalletPaymentMethodSection({
    super.key,
    required this.amount,
    this.showWalletOption = true,
    this.selectedId,
    this.onSelectedChanged,
    this.selectedFpxBankChannel,
    this.onFpxBankChanged,
  });

  final double amount;
  final bool showWalletOption;
  final String? selectedId;
  final ValueChanged<String>? onSelectedChanged;
  final String? selectedFpxBankChannel;
  final ValueChanged<String>? onFpxBankChanged;

  @override
  ConsumerState<WalletPaymentMethodSection> createState() =>
      _WalletPaymentMethodSectionState();
}

class _WalletPaymentMethodSectionState
    extends ConsumerState<WalletPaymentMethodSection> {
  late String _selectedId =
      widget.selectedId ?? WalletConfig.defaultPaymentMethodId;

  @override
  void initState() {
    super.initState();
    if (widget.showWalletOption) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(walletBalanceProvider.notifier).silentRefresh();
      });
    }
  }

  @override
  void didUpdateWidget(covariant WalletPaymentMethodSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != null && widget.selectedId != _selectedId) {
      _selectedId = widget.selectedId!;
    }
  }

  List<PaymentMethodItem> _buildMethods(PaymentQuoteModel quote) {
    final topupMethods = WalletConfig.topupPaymentMethods.map((method) {
      final methodQuote = quote.methodQuote(method.id);
      final feePercent = methodQuote?.feePercent ?? 0;
      final totalAmount = methodQuote?.totalAmount ?? quote.amount;

      return PaymentMethodItem(
        id: method.id,
        label: method.label,
        trailing: formatProcessingFeeLabel(feePercent),
        totalAmountLabel: formatPaymentAmountDisplay(totalAmount),
      );
    }).toList();

    if (!widget.showWalletOption) {
      return topupMethods;
    }

    final balanceAsync = ref.watch(walletBalanceProvider);
    final balanceDisplay = balanceAsync.maybeWhen(
      data: (balance) => formatWalletBalanceDisplay(balance),
      orElse: () => '0',
    );

    return [
      ...topupMethods,
      PaymentMethodItem(
        id: 'wallet',
        label: 'Wallet',
        trailing: 'Remaining: RM $balanceDisplay',
      ),
    ];
  }

  void _select(String id) {
    setState(() => _selectedId = id);
    widget.onSelectedChanged?.call(id);
  }

  Future<void> _openFpxBankPicker() async {
    if (widget.onFpxBankChanged == null) return;

    if (_selectedId != 'fpx') {
      _select('fpx');
    }

    final channel = await showFpxBankPickerSheet(
      context,
      selectedChannel: widget.selectedFpxBankChannel,
    );
    if (channel != null) {
      widget.onFpxBankChanged!(channel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final quoteAsync = ref.watch(paymentQuoteProvider(widget.amount));
    final quote = quoteAsync.maybeWhen(
      data: (value) => value,
      orElse: () => buildLocalPaymentQuote(widget.amount),
    );
    final methods = _buildMethods(quote);
    final showFpxBankPicker = widget.onFpxBankChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: brandBlue,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < methods.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 10,
                    thickness: 1.5,
                    color: brandBlue.withValues(alpha: 0.2),
                    indent: 16,
                    endIndent: 16,
                  ),
                _PaymentMethodTile(
                  method: methods[i],
                  selected: methods[i].id == _selectedId,
                  brandBlue: brandBlue,
                  onTap: () => _select(methods[i].id),
                  fpxBankChannel: methods[i].id == 'fpx' && showFpxBankPicker
                      ? widget.selectedFpxBankChannel
                      : null,
                  onFpxBankTap: methods[i].id == 'fpx' && showFpxBankPicker
                      ? _openFpxBankPicker
                      : null,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.brandBlue,
    required this.onTap,
    this.fpxBankChannel,
    this.onFpxBankTap,
  });

  final PaymentMethodItem method;
  final bool selected;
  final Color brandBlue;
  final VoidCallback onTap;
  final String? fpxBankChannel;
  final VoidCallback? onFpxBankTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
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
                      fontSize: 15,
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
            if (method.trailing != null || method.totalAmountLabel != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (method.trailing != null)
                    Text(
                      method.trailing!,
                      style: TextStyle(
                        fontSize: 12,
                        color: brandBlue.withValues(alpha: 0.45),
                      ),
                    ),
                  if (method.totalAmountLabel != null) ...[
                    if (method.trailing != null) const SizedBox(height: 4),
                    Text(
                      method.totalAmountLabel!,
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
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? brandBlue : brandBlue.withValues(alpha: 0.25),
          width: selected ? 3.9 : 1.5,
        ),
      ),
    );
  }
}
