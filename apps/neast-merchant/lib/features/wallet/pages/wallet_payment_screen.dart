import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';
import 'package:neast/features/wallet/models/wallet_payment_args.dart';
import 'package:neast/features/wallet/models/wallet_topup_model.dart';
import 'package:neast/features/wallet/providers/wallet_topup_list_provider.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';
import 'package:neast/features/wallet/widgets/wallet_payment_method_section.dart';
import 'package:neast/features/wallet/widgets/wallet_payment_success_dialog.dart';
import 'package:neast/features/wallet/widgets/wallet_topup_amount_summary_card.dart';

/// 钱包付款页。
class WalletPaymentScreen extends ConsumerStatefulWidget {
  const WalletPaymentScreen({
    super.key,
    required this.args,
  });

  final WalletPaymentArgs args;

  @override
  ConsumerState<WalletPaymentScreen> createState() =>
      _WalletPaymentScreenState();
}

class _WalletPaymentScreenState extends ConsumerState<WalletPaymentScreen> {
  late String _selectedPaymentMethodId = WalletConfig.defaultPaymentMethodId;
  String? _selectedFpxBankChannel;

  Future<void> _refreshWalletData() async {
    await EasyLoading.show();
    try {
      await ref.runGuarded(() async {
        await ref.read(merchantInfoProvider.notifier).refresh();
        await ref.read(walletTopupListProvider.notifier).refresh();
        return true;
      });
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _onMakePayment() async {
    if (_selectedPaymentMethodId == 'fpx' &&
        (_selectedFpxBankChannel == null ||
            _selectedFpxBankChannel!.isEmpty)) {
      ToastUtil.show('Please select a bank');
      return;
    }

    WalletTopupOrder? order;

    await EasyLoading.show();
    try {
      order = await ref.runGuarded(
        () => ref.read(walletServiceProvider).createTopupOrder(
              amount: widget.args.amount,
              paymentMethod: _selectedPaymentMethodId,
              paymentChannel: _selectedPaymentMethodId == 'fpx'
                  ? _selectedFpxBankChannel
                  : null,
            ),
      );
    } finally {
      await EasyLoading.dismiss();
    }

    if (order == null || !mounted) return;

    final paymentUrl = order.paymentUrl.trim();
    if (paymentUrl.isEmpty) {
      ToastUtil.show('Payment URL is unavailable');
      return;
    }

    final result = await context.push<int>(
      AppRoutes.payH5WebView,
      extra: {
        'url': paymentUrl,
        'title': 'Payment',
      },
    );

    if (!mounted) return;

    if (result == null) {
      ToastUtil.show('Payment cancelled');
      return;
    }

    if (result == 0) {
      await _refreshWalletData();
      if (!mounted) return;
      await WalletPaymentSuccessDialog.show();
      if (mounted) {
        context.pop();
      }
      return;
    }

    if (result == 1) {
      await _refreshWalletData();
      if (mounted) {
        ToastUtil.show('Payment is pending');
      }
      return;
    }

    ToastUtil.show('Payment failed');
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RichTextHeader(title: 'Wallet'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WalletTopupAmountSummaryCard(
                    amountLabel: widget.args.amountLabel,
                  ),
                  const SizedBox(height: 24),
                  WalletPaymentMethodSection(
                    amount: widget.args.amount,
                    showWalletOption: false,
                    selectedId: _selectedPaymentMethodId,
                    selectedFpxBankChannel: _selectedFpxBankChannel,
                    onSelectedChanged: (id) {
                      setState(() => _selectedPaymentMethodId = id);
                    },
                    onFpxBankChanged: (channel) {
                      setState(() => _selectedFpxBankChannel = channel);
                    },
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onMakePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Make Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'FD',
                          fontVariations: [FontVariation('wght', 500)],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Clicking the "button" above indicates your agreement to the Neast authorization agreement',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: brandBlue.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
