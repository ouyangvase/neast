import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/widgets/app_refresher.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/home_dashboard_model.dart';
import 'package:neast_landlords/features/home/providers/home_dashboard_provider.dart';
import 'package:neast_landlords/features/home/widgets/ack_card.dart';
import 'package:neast_landlords/features/home/widgets/bind_request_card.dart';
import 'package:neast_landlords/features/home/widgets/home_dashboard_skeleton.dart';
import 'package:neast_landlords/features/home/widgets/home_due_soon_card.dart';
import 'package:neast_landlords/features/home/widgets/home_need_action_card.dart';
import 'package:neast_landlords/features/home/widgets/home_overdue_rent_card.dart';
import 'package:neast_landlords/features/home/widgets/home_portfolio_snapshot_card.dart';
import 'package:neast_landlords/features/home/widgets/home_section_header.dart';
import 'package:neast_landlords/features/home/widgets/home_sliver_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  double _collapseProgress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final distance = HomeSliverHeader.collapseDistanceOf(context);
    final progress = (_scrollController.offset / distance).clamp(0.0, 1.0);
    if (progress != _collapseProgress) {
      setState(() => _collapseProgress = progress);
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(homeDashboardProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final dashboard = dashboardAsync.value;
    final showSkeleton = dashboard == null;

    ref.listen(homeDashboardProvider, (previous, next) {
      if (next.hasError && previous?.hasValue == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return ColoredBox(
      color: HomeColors.background,
      child: AppRefresher(
        headerPosition: IndicatorPosition.locator,
        scrollController: _scrollController,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            HomeSliverHeader(
              collapseProgress: _collapseProgress,
              collected: dashboard?.header.displayCollected ?? 'RM -',
              collectionRateText:
                  dashboard?.header.collectionRateText ?? '0% Collection Rate',
              overdueAmountText:
                  dashboard?.header.overdueAmountText ?? 'RM 0 Overdue',
              hasUnreadMessage: dashboard?.hasUnreadMessage ?? false,
              onMessage: () async {
                await context.push(AppRoutes.notification);
                if (!mounted) return;
                await ref.read(homeDashboardProvider.notifier).refresh();
              },
            ),
            const HeaderLocator.sliver(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: showSkeleton
                    ? const HomeDashboardSkeleton()
                    : _DashboardContent(dashboard: dashboard),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.dashboard});

  final HomeDashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    final needAction = dashboard.needAction;
    final portfolio = dashboard.portfolio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeNeedActionCard(
          overdue: needAction.overdue,
          dueSoon: needAction.dueSoon,
          needAck: needAction.needAck,
          bindReq: needAction.bindReq,
          tasksWaitingText: needAction.tasksWaitingText,
        ),
        if (dashboard.overdueList.isNotEmpty) ...[
          const SizedBox(height: 26),
          const HomeSectionHeader(title: 'Overdue Rent'),
          const SizedBox(height: 12),
          for (var i = 0; i < dashboard.overdueList.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            HomeOverdueRentCard(
              item: dashboard.overdueList[i],
              onView: () => context.push(
                AppRoutes.rentDetail,
                extra: dashboard.overdueList[i],
              ),
            ),
          ],
        ],
        if (dashboard.dueSoonList.isNotEmpty) ...[
          const SizedBox(height: 26),
          const HomeSectionHeader(title: 'Due Soon'),
          const SizedBox(height: 12),
          for (var i = 0; i < dashboard.dueSoonList.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            HomeDueSoonCard(
              item: dashboard.dueSoonList[i],
              onTap: () => context.push(
                AppRoutes.rentDetail,
                extra: dashboard.dueSoonList[i],
              ),
            ),
          ],
        ],
        if (dashboard.needAck != null) ...[
          const SizedBox(height: 26),
          HomeSectionHeader(
            title: 'Need Acknowledgement',
            onViewAll: () => context.push(AppRoutes.ackList),
          ),
          const SizedBox(height: 12),
          AckCard(
            item: dashboard.needAck!,
            onTap: () => context.push(
              AppRoutes.ackDetail,
              extra: dashboard.needAck,
            ),
          ),
        ],
        if (dashboard.bindRequest != null) ...[
          const SizedBox(height: 26),
          HomeSectionHeader(
            title: 'Pending Bind Requests',
            onViewAll: () => context.push(AppRoutes.bindRequestList),
          ),
          const SizedBox(height: 12),
          BindRequestCard(
            item: dashboard.bindRequest!,
            onTap: () => context.push(
              AppRoutes.bindRequestDetail,
              extra: dashboard.bindRequest,
            ),
          ),
        ],
        const SizedBox(height: 26),
        HomeSectionHeader(
          title: 'Portfolio Snapshot',
          actionText: 'Open',
          onViewAll: () => context.push(AppRoutes.portfolioSnapshot),
        ),
        const SizedBox(height: 12),
        HomePortfolioSnapshotSection(
          properties: portfolio.properties,
          tenants: portfolio.tenants,
          rentRoll: portfolio.displayRentRoll,
        ),
      ],
    );
  }
}
