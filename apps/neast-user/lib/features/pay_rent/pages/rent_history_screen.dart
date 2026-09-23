import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/providers/rent_history_provider.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_history_item.dart';

/// 还款历史完整列表页（由 Pay Rent View All push 进入）。
class RentHistoryScreen extends ConsumerStatefulWidget {
  const RentHistoryScreen({super.key});

  @override
  ConsumerState<RentHistoryScreen> createState() => _RentHistoryScreenState();
}

class _RentHistoryScreenState extends ConsumerState<RentHistoryScreen> {
  late final EasyRefreshController _refreshController;
  int? _loadedYear;
  bool _hasTriggeredLoad = false;

  static List<int?> get _yearOptions {
    final currentYear = DateTime.now().year;
    return [
      null,
      for (var i = 0; i < 10; i++) currentYear - i,
    ];
  }

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _ensureLoaded(int? year) {
    if (_hasTriggeredLoad && _loadedYear == year) return;
    _hasTriggeredLoad = true;
    _loadedYear = year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(rentHistoryListProvider(year).notifier).initialLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final selectedYear = ref.watch(rentHistoryYearProvider);
    _ensureLoaded(selectedYear);

    ref.listen<int?>(rentHistoryYearProvider, (prev, next) {
      if (prev != next) {
        _hasTriggeredLoad = false;
        _ensureLoaded(next);
      }
    });

    final listState = ref.watch(rentHistoryListProvider(selectedYear));
    final listNotifier = ref.read(rentHistoryListProvider(selectedYear).notifier);

    return ColoredBox(
      color: const Color(0xFFF6F9F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastBrandHeader(
            title: NeastBrandHeader.plainTitle('History'),
            fillColor: const Color(0xFFF6F9F6),
            onBack: () => context.pop(),
          ),
          const SizedBox(height: 16),
          _YearFilterBar(
            brandBlue: brandBlue,
            selectedYear: selectedYear,
            yearOptions: _yearOptions,
            onYearSelected: (year) {
              ref.read(rentHistoryYearProvider.notifier).state = year;
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _HistoryListView(
              brandBlue: brandBlue,
              listState: listState,
              refreshController: _refreshController,
              onRefresh: () => listNotifier.refresh(),
              onLoad: () async {
                await listNotifier.loadMore();
                return ref.read(rentHistoryListProvider(selectedYear)).hasMore;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _YearFilterBar extends StatelessWidget {
  const _YearFilterBar({
    required this.brandBlue,
    required this.selectedYear,
    required this.yearOptions,
    required this.onYearSelected,
  });

  final Color brandBlue;
  final int? selectedYear;
  final List<int?> yearOptions;
  final ValueChanged<int?> onYearSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: yearOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final year = yearOptions[index];
          final isSelected = selectedYear == year;
          final label = year == null ? 'All' : year.toString();

          return GestureDetector(
            onTap: () => onYearSelected(year),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? brandBlue : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? brandBlue
                      : brandBlue.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : brandBlue,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryListView extends StatelessWidget {
  const _HistoryListView({
    required this.brandBlue,
    required this.listState,
    required this.refreshController,
    required this.onRefresh,
    required this.onLoad,
  });

  final Color brandBlue;
  final PaginatedListState<RentHistoryModel> listState;
  final EasyRefreshController refreshController;
  final Future<void> Function() onRefresh;
  final Future<bool> Function() onLoad;

  @override
  Widget build(BuildContext context) {
    if (listState.isLoading && listState.list.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = listState.list;

    if (items.isEmpty) {
      return AppRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: Center(
                child: Text(
                  'No payment history',
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

    final itemCount = items.length + (listState.hasMore ? 0 : 1);

    return AppRefresher(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                for (var i = 0; i < items.length; i++)
                  PayRentHistoryTile(
                    item: items[i],
                    showDivider: i < items.length - 1,
                    showStatus: true,
                    onTap: items[i].isPaidDetailAvailable
                        ? () => context.push(
                              AppRoutes.rentHistoryDetail,
                              extra: items[i],
                            )
                        : null,
                  ),
              ],
            ),
          ),
          if (itemCount > items.length)
            Padding(
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
        ],
      ),
    );
  }
}
