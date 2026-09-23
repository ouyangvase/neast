import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_list_provider.dart';
import 'package:neast/features/pay_rent/providers/rent_detail_history_provider.dart';
import 'package:neast/features/pay_rent/providers/rent_history_provider.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_item_card.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';
import 'package:neast/features/wallet/providers/wallet_balance_provider.dart';
import 'package:neast/features/wallet/widgets/wallet_payment_method_section.dart';

/// 租金支付页：展示当前租金信息 + 支付方式选择。
class PayRentPaymentScreen extends ConsumerStatefulWidget {
  const PayRentPaymentScreen({
    super.key,
    required this.rent,
  });

  final RentModel rent;

  @override
  ConsumerState<PayRentPaymentScreen> createState() =>
      _PayRentPaymentScreenState();
}

class _PayRentPaymentScreenState extends ConsumerState<PayRentPaymentScreen> {
  late String _selectedPaymentMethodId = 'fpx';
  String? _selectedFpxBankChannel;
  final _holderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _holderController.text = widget.rent.displayLandlordName;
  }

  @override
  void dispose() {
    _holderController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  Map<String, String>? _unboundBankPayload() {
    if (widget.rent.hasLandlord) return null;
    final holder = _holderController.text.trim();
    final bank = _bankNameController.text.trim();
    final account = _bankAccountController.text.trim();
    if (holder.isEmpty || bank.isEmpty || account.length < 6) {
      return null;
    }
    return {
      'owner_account_holder': holder,
      'owner_bank_name': bank,
      'owner_bank_account': account,
    };
  }

  Future<void> _refreshRentData() async {
    ref.invalidate(payRentListProvider);
    ref.invalidate(payRentRecentHistoryProvider);
    ref.invalidate(rentDetailHistoryProvider(widget.rent.id));
  }

  Future<RentHistoryModel?> _waitForPaidHistory(int historyId) async {
    for (var attempt = 0; attempt < 5; attempt++) {
      if (!mounted) return null;

      final items = await ref.read(rentServiceProvider).fetchHistoryByRentId(
            widget.rent.id,
          );
      for (final item in items) {
        if (item.id == historyId && item.isPaidDetailAvailable) {
          return item;
        }
      }

      if (attempt < 4) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }

    return null;
  }

  Future<void> _onWalletPayment() async {
    await EasyLoading.show();
    try {
      final bank = _unboundBankPayload();
      final result = await ref.runGuarded(
        () => ref.read(rentServiceProvider).payByWallet(
              rentId: widget.rent.id,
              paymentMethod: _selectedPaymentMethodId,
              ownerAccountHolder: bank?['owner_account_holder'],
              ownerBankName: bank?['owner_bank_name'],
              ownerBankAccount: bank?['owner_bank_account'],
            ),
      );
      if (result == null || !mounted) return;

      await ref.read(walletBalanceProvider.notifier).silentRefresh();
      await _refreshRentData();

      if (!mounted) return;
      context.pushReplacement(
        AppRoutes.rentHistoryDetail,
        extra: result,
      );
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _onH5Payment() async {
    if (_selectedPaymentMethodId == 'fpx' &&
        (_selectedFpxBankChannel == null ||
            _selectedFpxBankChannel!.isEmpty)) {
      ToastUtil.show('Please select a bank');
      return;
    }

    RentPayOrder? order;

    await EasyLoading.show();
    try {
      order = await ref.runGuarded(
        () => ref.read(rentServiceProvider).createPayOrder(
              rentId: widget.rent.id,
              paymentMethod: _selectedPaymentMethodId,
              paymentChannel: _selectedPaymentMethodId == 'fpx'
                  ? _selectedFpxBankChannel
                  : null,
              ownerAccountHolder: _unboundBankPayload()?['owner_account_holder'],
              ownerBankName: _unboundBankPayload()?['owner_bank_name'],
              ownerBankAccount: _unboundBankPayload()?['owner_bank_account'],
            ),
      );
    } finally {
      await EasyLoading.dismiss();
    }

    if (order == null || !mounted) return;

    final paymentUrl = order.paymentUrl.trim();
    if (paymentUrl.isEmpty) {
      await _refreshRentData();
      if (!mounted) return;
      final history = await _waitForPaidHistory(order.historyId);
      if (!mounted) return;
      if (history != null) {
        context.pushReplacement(
          AppRoutes.rentHistoryDetail,
          extra: history,
        );
        return;
      }
      ToastUtil.show('Payment received, please check payment history');
      context.pop();
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
      await _refreshRentData();
      if (!mounted) return;

      final history = await _waitForPaidHistory(order.historyId);
      if (!mounted) return;

      if (history != null) {
        context.pushReplacement(
          AppRoutes.rentHistoryDetail,
          extra: history,
        );
        return;
      }

      ToastUtil.show('Payment received, please check payment history');
      context.pop();
      return;
    }

    if (result == 1) {
      await _refreshRentData();
      if (mounted) {
        ToastUtil.show('Payment is pending');
      }
      return;
    }

    ToastUtil.show('Payment failed');
  }

  Future<void> _onMakePayment() async {
    if (!widget.rent.hasLandlord && _unboundBankPayload() == null) {
      ToastUtil.show('Enter the owner bank details before paying');
      return;
    }

    if (_selectedPaymentMethodId == 'wallet') {
      await _onWalletPayment();
      return;
    }

    await _onH5Payment();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RichTextHeader(title: 'Payment Method'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PayRentItemCard(rent: widget.rent, showPayButton: false),
                  const SizedBox(height: 16),
                  _PaymentDestinationCard(rent: widget.rent),
                  if (!widget.rent.hasLandlord) ...[
                    const SizedBox(height: 16),
                    _OwnerBankFields(
                      holderController: _holderController,
                      bankNameController: _bankNameController,
                      bankAccountController: _bankAccountController,
                    ),
                  ],
                  const SizedBox(height: 24),
                  WalletPaymentMethodSection(
                    amount: double.tryParse(widget.rent.amount) ?? 0,
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

class _PaymentDestinationCard extends StatelessWidget {
  const _PaymentDestinationCard({required this.rent});

  final RentModel rent;

  @override
  Widget build(BuildContext context) {
    final bound = rent.hasLandlord;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bound ? 'Pays to NEAST, then owner bank' : 'Pays to NEAST and is held',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 500)],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bound
                ? '${rent.displayLandlordName} · ${rent.destinationBankLabel}. Status only — admin or backend still sends the transfer later. Not an owner wallet.'
                : 'This owner is not on NEAST. Enter their bank below. After pay, NEAST holds the money until they join.',
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerBankFields extends StatelessWidget {
  const _OwnerBankFields({
    required this.holderController,
    required this.bankNameController,
    required this.bankAccountController,
  });

  final TextEditingController holderController;
  final TextEditingController bankNameController;
  final TextEditingController bankAccountController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Owner bank (first time)',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 500)],
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: holderController,
          decoration: const InputDecoration(
            labelText: 'Account holder',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: bankNameController,
          decoration: const InputDecoration(
            labelText: 'Bank name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: bankAccountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Account number',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
