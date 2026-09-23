import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/pagination/paginated_list_state.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/utils/notifier_utils.dart';
import 'package:neast_landlords/core/widgets/app_refresher.dart';
import 'package:neast_landlords/features/notification/models/notification_model.dart';
import 'package:neast_landlords/features/notification/providers/notification_list_provider.dart';
import 'package:neast_landlords/features/notification/services/notification_service.dart';
import 'package:neast_landlords/features/notification/widgets/notification_item_card.dart';
import 'package:neast_landlords/features/rich_text/widgets/rich_text_header.dart';

/// 消息通知页面。
class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  late final EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.runGuarded(
        () => ref.read(notificationServiceProvider).markAllRead(),
      );
      if (!mounted) return;
      await ref.read(notificationListProvider.notifier).initialLoad();
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
    final listState = ref.watch(notificationListProvider);
    final listNotifier = ref.read(notificationListProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RichTextHeader(title: 'Notification'),
          Expanded(
            child: _NotificationListView(
              brandBlue: brandBlue,
              listState: listState,
              refreshController: _refreshController,
              onRefresh: () => listNotifier.refresh(),
              onLoad: () async {
                await listNotifier.loadMore();
                return ref.read(notificationListProvider).hasMore;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationListView extends StatelessWidget {
  const _NotificationListView({
    required this.brandBlue,
    required this.listState,
    required this.refreshController,
    required this.onRefresh,
    required this.onLoad,
  });

  final Color brandBlue;
  final PaginatedListState<NotificationModel> listState;
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
                  'No notifications yet',
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return NotificationItemCard(item: items[index]);
        },
      ),
    );
  }
}
