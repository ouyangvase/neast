import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/points/models/points_log_model.dart';
import 'package:neast/features/points/providers/points_log_list_provider.dart';
import 'package:neast/features/points/widgets/points_history_item.dart';

/// 积分收支流水页。
class PointsHistoryScreen extends ConsumerStatefulWidget {
  const PointsHistoryScreen({super.key});

  @override
  ConsumerState<PointsHistoryScreen> createState() =>
      _PointsHistoryScreenState();
}

class _PointsHistoryScreenState extends ConsumerState<PointsHistoryScreen> {
  late final EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pointsLogListProvider.notifier).initialLoad();
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
    final listState = ref.watch(pointsLogListProvider);
    final listNotifier = ref.read(pointsLogListProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Points History',
          style: TextStyle(
            fontFamily: 'FD',
            fontSize: 20,
            color: Colors.black,
            fontVariations: [FontVariation('wght', 400)],
          ),
        ),
      ),
      body: _PointsHistoryListView(
        brandBlue: brandBlue,
        listState: listState,
        refreshController: _refreshController,
        onRefresh: () => listNotifier.refresh(),
        onLoad: () async {
          await listNotifier.loadMore();
          return ref.read(pointsLogListProvider).hasMore;
        },
      ),
    );
  }
}

class _PointsHistoryListView extends StatelessWidget {
  const _PointsHistoryListView({
    required this.brandBlue,
    required this.listState,
    required this.refreshController,
    required this.onRefresh,
    required this.onLoad,
  });

  final Color brandBlue;
  final PaginatedListState<PointsLogModel> listState;
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
                  'No points history yet',
                  style: TextStyle(
                    fontSize: 14,
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
        itemCount: items.length + (listState.hasMore ? 0 : 1),
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          color: brandBlue.withValues(alpha: 0.08),
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
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

          return PointsHistoryItem(item: items[index]);
        },
      ),
    );
  }
}
