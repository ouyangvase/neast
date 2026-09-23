import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/common/widgets/guest_login_placeholder.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_list_provider.dart';
import 'package:neast/features/pay_rent/providers/rent_history_provider.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_add_tenancy_tile.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_card_shadow.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_history_section.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_tenancy_card.dart';

/// Pay Rent 主页面（一级 Tab）：AppBar + 可滚动 Column（蓝拼接区 + 白色内容区，区内内容上移）。
class PayRentScreen extends ConsumerStatefulWidget {
  const PayRentScreen({super.key});

  @override
  ConsumerState<PayRentScreen> createState() => _PayRentScreenState();
}

class _PayRentScreenState extends ConsumerState<PayRentScreen> {
  /// AppBar 下方品牌浅蓝拼接区最大高度。
  static const _blueExtension = 40.0;

  /// 白色内容区顶部圆角。
  static const _contentTopRadius = 22.0;

  late final ScrollController _scrollController;
  late final EasyRefreshController _refreshController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset == _scrollOffset) return;
    setState(() => _scrollOffset = offset);
  }

  double get _blueStripHeight =>
      (_blueExtension - _scrollOffset).clamp(0.0, _blueExtension);

  double get _animatedContentTopRadius =>
      (_contentTopRadius - _scrollOffset).clamp(0.0, _contentTopRadius);

  Future<void> _onRefresh() async {
    ref.invalidate(payRentListProvider);
    ref.invalidate(payRentRecentHistoryProvider);
    await Future.wait([
      ref.read(payRentListProvider.future),
      ref.read(payRentRecentHistoryProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final rentListAsync = isLoggedIn
        ? ref.watch(payRentListProvider)
        : const AsyncValue.data(RentListResponse());
    final rentItems = rentListAsync.maybeWhen(
      data: (response) => response.items,
      orElse: () => const <RentModel>[],
    );
    final isLoading = rentListAsync.isLoading;
    final showAddTenancy = rentListAsync.maybeWhen(
      data: (response) => response.items.isEmpty && response.total == 0,
      orElse: () => false,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brandBlueLight,
        appBar: AppBar(
          backgroundColor: brandBlueLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Pay Rent',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'HG',
              color: Colors.white,
              fontVariations: [FontVariation('wght', 500)],
            ),
          ),
        ),
        body: isLoggedIn
            ? Column(
                children: [
                  ColoredBox(
                    color: brandBlueLight,
                    child: SizedBox(height: _blueStripHeight),
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(_animatedContentTopRadius),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -_blueExtension,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AppRefresher(
                            controller: _refreshController,
                            scrollController: _scrollController,
                            onRefresh: _onRefresh,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ..._buildRentCards(rentItems, isLoading),
                                    const SizedBox(height: 12),
                                    const PayRentHistorySection(),
                                    if (showAddTenancy) ...[
                                      const SizedBox(height: 12),
                                      const PayRentAddTenancyTile(),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  ColoredBox(
                    color: brandBlueLight,
                    child: SizedBox(height: _blueStripHeight),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(_contentTopRadius),
                        ),
                      ),
                      child: const GuestLoginPlaceholder(
                        iconAsset: 'assets/images/pay_rent/unlogin.png',
                        message: 'Log in to manage your rent payments',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _buildRentCards(List<RentModel> items, bool isLoading) {
    if (isLoading && items.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (items.isEmpty) {
      return [_EmptyTenancyCard()];
    }
    return [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0) const SizedBox(height: 12),
        PayRentTenancyCard(rent: items[i]),
      ],
    ];
  }
}

class _EmptyTenancyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Center(
        child: Text(
          'No active tenancy',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 400)],
            color: brandBlue.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
