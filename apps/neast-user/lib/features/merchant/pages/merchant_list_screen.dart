import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';
import 'package:neast/features/home/widgets/suggested_merchant_item.dart';
import 'package:neast/features/merchant/models/merchant_list_kind.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/providers/merchant_list_provider.dart';

/// 商家分页列表页（全部 / 推荐 / 附近）。
class MerchantListScreen extends ConsumerStatefulWidget {
  const MerchantListScreen({
    super.key,
    required this.kind,
    required this.headerTitle,
  });

  final MerchantListKind kind;
  final MerchantListHeaderTitle headerTitle;

  @override
  ConsumerState<MerchantListScreen> createState() => _MerchantListScreenState();
}

class _MerchantListScreenState extends ConsumerState<MerchantListScreen> {
  late final EasyRefreshController _refreshController;

  static const _backgroundColor = Color(0xFFF6F9F6);

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantListProvider(widget.kind).notifier).initialLoad();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final listState = ref.watch(merchantListProvider(widget.kind));
    final listNotifier = ref.read(merchantListProvider(widget.kind).notifier);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastBrandHeader(
            title: NeastBrandHeader.plainTitle(widget.headerTitle.label),
            fillColor: _backgroundColor,
          ),
          Expanded(
            child: listNotifier.locationUnavailable
                ? _LocationUnavailableHint(brandBlue: brandBlue)
                : _MerchantListView(
                    brandBlue: brandBlue,
                    listState: listState,
                    refreshController: _refreshController,
                    onRefresh: () => listNotifier.refresh(),
                    onLoad: () async {
                      await listNotifier.loadMore();
                      return ref.read(merchantListProvider(widget.kind)).hasMore;
                    },
                    onItemTap: (merchant) =>
                        context.push(AppRoutes.merchantDetail(merchant.id)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LocationUnavailableHint extends StatelessWidget {
  const _LocationUnavailableHint({required this.brandBlue});

  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'Enable location to see nearby merchants',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: brandBlue.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _MerchantListView extends StatelessWidget {
  const _MerchantListView({
    required this.brandBlue,
    required this.listState,
    required this.refreshController,
    required this.onRefresh,
    required this.onLoad,
    required this.onItemTap,
  });

  final Color brandBlue;
  final PaginatedListState<MerchantModel> listState;
  final EasyRefreshController refreshController;
  final Future<void> Function() onRefresh;
  final Future<bool> Function() onLoad;
  final ValueChanged<MerchantModel> onItemTap;

  @override
  Widget build(BuildContext context) {
    if (listState.isLoading && listState.list.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final items = listState.list;

    if (items.isEmpty) {
      return AppRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: Center(
                child: Text(
                  'No nearby merchants',
                  style: TextStyle(
                    fontSize: 13,
                    color: brandBlue.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AppRefresher(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length + (listState.hasMore ? 0 : 1),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "That's all for now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: brandBlue.withValues(alpha: 0.4),
                ),
              ),
            );
          }

          final merchant = items[index];
          return SuggestedMerchantTile(
            merchant: merchant,
            onTap: () => onItemTap(merchant),
          );
        },
      ),
    );
  }
}
