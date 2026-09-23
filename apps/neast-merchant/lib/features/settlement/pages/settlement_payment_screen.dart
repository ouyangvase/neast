import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/common/widgets/success_result_dialog.dart';
import 'package:neast/features/settlement/models/settlement_overview_model.dart';
import 'package:neast/features/settlement/providers/settlement_overview_provider.dart';
import 'package:neast/features/settlement/services/settlement_service.dart';
import 'package:neast/features/settlement/settlement_colors.dart';
import 'package:neast/features/settlement/settlement_constants.dart';
import 'package:neast/features/settlement/widgets/settlement_payment_amount_card.dart';
import 'package:neast/features/settlement/widgets/settlement_payment_header.dart';
import 'package:neast/features/settlement/widgets/settlement_payment_method_card.dart';

/// Settlement 支付页。
class SettlementPaymentScreen extends ConsumerStatefulWidget {
  const SettlementPaymentScreen({super.key});

  static const _amountCardOverlap = 25.0;
  static const _amountCardHeight = 84.0;

  @override
  ConsumerState<SettlementPaymentScreen> createState() =>
      _SettlementPaymentScreenState();
}

class _SettlementPaymentScreenState
    extends ConsumerState<SettlementPaymentScreen> {
  SettlementPaymentMethod _selectedMethod = SettlementPaymentMethod.fpx;
  String? _selectedFpxBankChannel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantInfoProvider.notifier).fetchIfNeeded();
    });
  }

  Future<void> _refreshSettlementData() async {
    await ref.read(settlementOverviewProvider.notifier).fetch(silent: true);
    await ref.read(merchantInfoProvider.notifier).refresh();
  }

  Future<void> _showPaymentSuccess() async {
    if (!mounted) return;
    await SuccessResultDialog.show(
      imageAsset: 'assets/images/settlement/success.png',
      message: 'Payment successful',
      onClose: () {
        if (mounted) context.pop();
      },
    );
  }

  Future<void> _onWalletPayment(int billId) async {
    await EasyLoading.show();
    try {
      final result = await ref.runGuarded(
        () => ref.read(settlementServiceProvider).payByWallet(
              billId: billId,
              paymentMethod: _selectedMethod.apiId,
            ),
      );
      if (result == null || !mounted) return;

      ref.read(settlementOverviewProvider.notifier).fetch(silent: true);
      await ref.read(merchantInfoProvider.notifier).refresh();

      if (!mounted) return;
      await _showPaymentSuccess();
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _onH5Payment(int billId) async {
    if (_selectedMethod == SettlementPaymentMethod.fpx &&
        (_selectedFpxBankChannel == null ||
            _selectedFpxBankChannel!.isEmpty)) {
      ToastUtil.show('Please select a bank');
      return;
    }

    SettlementPayOrder? order;

    await EasyLoading.show();
    try {
      order = await ref.runGuarded(
        () => ref.read(settlementServiceProvider).createPayOrder(
              billId: billId,
              paymentMethod: _selectedMethod.apiId,
              paymentChannel: _selectedMethod == SettlementPaymentMethod.fpx
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
      await EasyLoading.show();
      try {
        await ref.runGuarded(() async {
          await _refreshSettlementData();
          return true;
        });
      } finally {
        await EasyLoading.dismiss();
      }
      if (!mounted) return;
      await _showPaymentSuccess();
      return;
    }

    if (result == 1) {
      await _refreshSettlementData();
      if (mounted) {
        ToastUtil.show('Payment is pending');
      }
      return;
    }

    ToastUtil.show('Payment failed');
  }

  Future<void> _onMakePayment() async {
    final overview = ref.read(settlementOverviewProvider).value;
    final billId = overview?.id;
    if (billId == null || overview?.showPayNow != true) {
      ToastUtil.show('No payment due');
      return;
    }

    if (_selectedMethod == SettlementPaymentMethod.wallet) {
      await _onWalletPayment(billId);
      return;
    }

    await _onH5Payment(billId);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final headerHeight = SettlementPaymentHeader.imageHeightOf(context);
    final paymentAmount =
        double.tryParse(ref.watch(settlementOverviewProvider).value?.amount ?? '') ??
            0;

    return Scaffold(
      backgroundColor: SettlementColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: headerHeight +
                SettlementPaymentScreen._amountCardHeight -
                SettlementPaymentScreen._amountCardOverlap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const SettlementPaymentHeader(),
                Positioned(
                  left: 16,
                  right: 16,
                  top: headerHeight -
                      SettlementPaymentScreen._amountCardOverlap,
                  child: const SettlementPaymentAmountCard(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SettlementPaymentMethodCard(
                    amount: paymentAmount,
                    selectedMethod: _selectedMethod,
                    selectedFpxBankChannel: _selectedFpxBankChannel,
                    onChanged: (method) {
                      setState(() => _selectedMethod = method);
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _onMakePayment,
                    behavior: HitTestBehavior.opaque,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: brandBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Center(
                          child: Text(
                            'Make Payment',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'FD',
                              fontVariations: [FontVariation('wght', 500)],
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Clicking the 'button' above indicates your agreement to the Neast authorization agreement",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.35,
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
