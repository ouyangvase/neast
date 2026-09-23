import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';
import 'package:neast/features/wallet/models/wallet_payment_args.dart';
import 'package:neast/features/wallet/providers/wallet_topup_list_provider.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';
import 'package:neast/features/wallet/widgets/wallet_balance_card.dart';
import 'package:neast/features/wallet/widgets/wallet_topup_amount_section.dart';
import 'package:neast/features/wallet/widgets/wallet_topup_record_section.dart';

/// 钱包充值页。
class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  static const _monthLabels = [
    'Jan.',
    'Feb.',
    'Mar.',
    'Apr.',
    'May.',
    'Jun.',
    'Jul.',
    'Aug.',
    'Sep.',
    'Oct.',
    'Nov.',
    'Dec.',
  ];

  late final EasyRefreshController _refreshController;
  int? _selectedAmount = WalletConfig.presetAmounts.first;
  bool _isCustomSelected = false;
  final _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantInfoProvider.notifier).fetchIfNeeded();
      ref.read(walletTopupListProvider.notifier).initialLoad();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _customController.dispose();
    super.dispose();
  }

  String get _currentMonthLabel =>
      _monthLabels[DateTime.now().month - 1];

  void _onAmountSelected(int amount) {
    setState(() {
      _selectedAmount = amount;
      _isCustomSelected = false;
      _customController.clear();
    });
  }

  void _onCustomTap() {
    setState(() {
      _isCustomSelected = true;
      _selectedAmount = null;
    });
  }

  double? _resolveAmount() {
    if (_isCustomSelected) {
      final text = _customController.text.trim();
      if (text.isEmpty) return null;
      final normalized = text.toUpperCase().startsWith('RM')
          ? text.substring(2).trim()
          : text;
      return double.tryParse(normalized);
    }
    return _selectedAmount?.toDouble();
  }

  String? _resolveAmountLabel(double amount) {
    final formatted = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return 'RM $formatted';
  }

  void _onTopUp() {
    final amount = _resolveAmount();
    if (amount == null || amount <= 0) {
      ToastUtil.show('Please enter a valid amount');
      return;
    }
    context.push(
      AppRoutes.walletPayment,
      extra: WalletPaymentArgs(
        amount: amount,
        amountLabel: _resolveAmountLabel(amount)!,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(merchantInfoProvider.notifier).refresh(),
      ref.read(walletTopupListProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final merchantInfo = ref.watch(merchantInfoProvider).value;
    final listState = ref.watch(walletTopupListProvider);
    final listNotifier = ref.read(walletTopupListProvider.notifier);

    final balanceDisplay = formatWalletBalanceDisplay(
      merchantInfo?.balance ?? '0',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const RichTextHeader(title: 'My Wallet'),
            Expanded(
              child: AppRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoad: () async {
                  await listNotifier.loadMore();
                  return ref.read(walletTopupListProvider).hasMore;
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    WalletBalanceCard(balance: balanceDisplay),
                    const SizedBox(height: 24),
                    WalletTopupAmountSection(
                      amounts: WalletConfig.presetAmounts,
                      selectedAmount: _selectedAmount,
                      onAmountSelected: _onAmountSelected,
                      customController: _customController,
                      onCustomTap: _onCustomTap,
                      isCustomSelected: _isCustomSelected,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _onTopUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Top up',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'FD',
                            fontVariations: [FontVariation('wght', 500)],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    WalletTopupRecordSection(
                      records: listState.list,
                      month: _currentMonthLabel,
                      isLoading: listState.isLoading && listState.list.isEmpty,
                      hasMore: listState.hasMore,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
