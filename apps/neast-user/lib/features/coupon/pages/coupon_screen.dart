import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_detail_args.dart';
import 'package:neast/features/coupon/providers/coupon_list_provider.dart';
import 'package:neast/features/coupon/widgets/coupon_category_tabs.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';
import 'package:neast/features/coupon/widgets/coupon_reward_list_view.dart';
import 'package:neast/features/coupon/widgets/coupon_screen_skeleton.dart';

/// 优惠券兑换页。
class CouponScreen extends ConsumerStatefulWidget {
  const CouponScreen({super.key});

  @override
  ConsumerState<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends ConsumerState<CouponScreen> {
  int? _selectedCategoryId;
  late final EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(couponCategoriesProvider);
      ref.read(couponListProvider(_selectedCategoryId).notifier).initialLoad();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    setState(() => _selectedCategoryId = categoryId);
    ref.read(couponListProvider(categoryId).notifier).initialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final categoriesAsync = ref.watch(couponCategoriesProvider);
    final listState = ref.watch(couponListProvider(_selectedCategoryId));
    final listNotifier = ref.read(couponListProvider(_selectedCategoryId).notifier);
    final isInitialLoading = categoriesAsync.isLoading &&
        listState.isLoading &&
        listState.list.isEmpty;

    if (isInitialLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: CouponScreenSkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastBrandHeader(title: NeastBrandHeader.neastRichTitle('rewards')),
          const SizedBox(height: 20),
          categoriesAsync.when(
            loading: () => const CouponCategoryTabsSkeleton(),
            error: (_, __) => const SizedBox.shrink(),
            data: (categories) => CouponCategoryTabs(
              categories: categories,
              selectedCategoryId: _selectedCategoryId,
              onSelected: _onCategorySelected,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: listState.isLoading && listState.list.isEmpty
                ? const CouponListSkeleton()
                : CouponRewardListView(
                    brandBlue: brandBlue,
                    listState: listState,
                    refreshController: _refreshController,
                    onRefresh: () => listNotifier.refresh(),
                    onLoad: () async {
                      await listNotifier.loadMore();
                      return ref.read(couponListProvider(_selectedCategoryId)).hasMore;
                    },
                    onItemTap: (item) => context.push(
                      AppRoutes.couponDetail,
                      extra: CouponDetailArgs(
                        item: item,
                        listCategoryId: _selectedCategoryId,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
