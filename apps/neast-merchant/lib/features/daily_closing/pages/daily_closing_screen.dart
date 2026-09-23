import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/common/widgets/neast_subpage_header_section.dart';
import 'package:neast/features/daily_closing/daily_closing_constants.dart';
import 'package:neast/features/daily_closing/providers/daily_closing_summary_provider.dart';
import 'package:neast/features/daily_closing/providers/daily_closing_transaction_list_provider.dart';
import 'package:neast/features/daily_closing/widgets/daily_closing_summary_card.dart';
import 'package:neast/features/daily_closing/widgets/daily_closing_transaction_tile.dart';

class DailyClosingScreen extends ConsumerStatefulWidget {
  const DailyClosingScreen({super.key});

  @override
  ConsumerState<DailyClosingScreen> createState() => _DailyClosingScreenState();
}

class _DailyClosingScreenState extends ConsumerState<DailyClosingScreen> {
  late final EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(dailyClosingTransactionListProvider.notifier).initialLoad();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(dailyClosingSummaryProvider.notifier).fetch(silent: true),
      ref.read(dailyClosingTransactionListProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final subtitle = DateFormat('dd MMM yyyy', 'en_US').format(DateTime.now());
    final listState = ref.watch(dailyClosingTransactionListProvider);
    final listNotifier = ref.read(dailyClosingTransactionListProvider.notifier);

    return Scaffold(
      backgroundColor: DailyClosingColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastSubpageHeaderOverlapLayout(
            subtitle: subtitle,
            title: 'Daily Closing',
            fillColor: DailyClosingColors.background,
            overlapChild: const DailyClosingSummaryCard(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'FD',
                fontVariations: [FontVariation('wght', 500)],
                color: brandBlue,
              ),
            ),
          ),
          Expanded(
            child: listState.isLoading && listState.list.isEmpty
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
                : AppRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoad: () async {
                      await listNotifier.loadMore();
                      return ref.read(dailyClosingTransactionListProvider).hasMore;
                    },
                    child: listState.list.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'No records',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: brandBlue.withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: listState.list.length,
                            itemBuilder: (context, index) {
                              return DailyClosingTransactionTile(
                                transaction: listState.list[index],
                              );
                            },
                          ),
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: brandBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: brandBlue.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  child: Text(
                    'Export Report',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'FD',
                      fontVariations: [FontVariation('wght', 500)],
                      color: brandBlue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
