import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/coupon/models/coupon_detail_args.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/providers/my_voucher_list_provider.dart';
import 'package:neast/features/coupon/widgets/my_voucher_card.dart';
import 'package:neast/features/coupon/widgets/my_voucher_tabs.dart';

/// 我的优惠券单个 Tab 列表面板。
class MyVoucherListPanel extends ConsumerStatefulWidget {
  const MyVoucherListPanel({
    super.key,
    required this.status,
  });

  final MyVoucherStatus status;

  @override
  ConsumerState<MyVoucherListPanel> createState() => _MyVoucherListPanelState();
}

class _MyVoucherListPanelState extends ConsumerState<MyVoucherListPanel>
    with AutomaticKeepAliveClientMixin {
  late final EasyRefreshController _refreshController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myVoucherListProvider(widget.status).notifier).initialLoad();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final brandBlue = context.appColors.brandBlue;
    final listState = ref.watch(myVoucherListProvider(widget.status));
    final listNotifier = ref.read(myVoucherListProvider(widget.status).notifier);
    final items = listState.list;

    return AppRefresher(
      controller: _refreshController,
      onRefresh: () => listNotifier.refresh(),
      onLoad: items.isEmpty
          ? null
          : () async {
              await listNotifier.loadMore();
              return ref.read(myVoucherListProvider(widget.status)).hasMore;
            },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                myVoucherSectionTitle(widget.status),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 700)],
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),
          if (listState.isLoading && items.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (items.isEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: Center(
                  child: Text(
                    myVoucherEmptyText(widget.status),
                    style: TextStyle(
                      fontSize: 13,
                      color: brandBlue.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return MyVoucherCard(
                    item: item,
                    onUseNow: item.isMyVoucherActionEnabled
                        ? () => context.push(
                              AppRoutes.couponDetail,
                              extra: CouponDetailArgs(
                                item: item,
                                fromMyVouchers: true,
                              ),
                            )
                        : null,
                  );
                },
              ),
            ),
          if (!listState.hasMore && items.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "That's all for now.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: brandBlue.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: _MyVoucherFooterNotice(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyVoucherFooterNotice extends StatelessWidget {
  const _MyVoucherFooterNotice();

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: brandBlue.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Coupons will be automatically applied at checkout',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: brandBlue.withValues(alpha: 0.45),
            ),
          ),
        ),
      ],
    );
  }
}
