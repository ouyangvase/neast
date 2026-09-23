import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/widgets/app_refresher.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/ack_list_header.dart';
import 'package:neast_landlords/features/records/providers/record_list_provider.dart';
import 'package:neast_landlords/features/records/widgets/record_month_picker.dart';
import 'package:neast_landlords/features/records/widgets/records_list_card.dart';

/// 收款记录页。
class RecordsScreen extends ConsumerStatefulWidget {
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> {
  late final EasyRefreshController _refreshController;
  late DateTime _selectedMonth;

  RecordListArg get _listArg => (
        year: _selectedMonth.year,
        month: _selectedMonth.month,
      );

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recordListProvider(_listArg).notifier).initialLoad();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _pickMonth() async {
    final picked = await showRecordMonthPicker(
      context: context,
      initial: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (!mounted || picked == null) return;

    setState(() {
      _selectedMonth = DateTime(picked.year, picked.month);
    });
    ref.read(recordAmountSumProvider.notifier).state = '0';
    await ref.read(recordListProvider(_listArg).notifier).initialLoad();
  }

  String _formatAmountSum(String raw) {
    final value = double.tryParse(raw) ?? 0;
    return NumberFormat('#,##0.##', 'en_US').format(value);
  }

  String _formatMonthLabel(DateTime date) {
    return DateFormat('MMM.yyyy', 'en_US').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final listState = ref.watch(recordListProvider(_listArg));
    final amountSum = ref.watch(recordAmountSumProvider);

    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AckListHeader(
            title: 'Records',
            showBackButton: false,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  'Total: RM${_formatAmountSum(amountSum)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                ),
                const Spacer(),
                _MonthChip(
                  label: _formatMonthLabel(_selectedMonth),
                  brandBlue: brandBlue,
                  onTap: _pickMonth,
                ),
              ],
            ),
          ),
          Expanded(
            child: AppRefresher(
              controller: _refreshController,
              onRefresh: () =>
                  ref.read(recordListProvider(_listArg).notifier).refresh(),
              onLoad: () async {
                await ref.read(recordListProvider(_listArg).notifier).loadMore();
                return ref.read(recordListProvider(_listArg)).hasMore;
              },
              child: listState.isLoading && listState.list.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : listState.list.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(
                              child: Text(
                                'No records yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: HomeColors.label,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: [
                            RecordsListCard(items: listState.list),
                          ],
                        ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: brandBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Generate PDF',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Colors.white,
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

class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.label,
    required this.brandBlue,
    required this.onTap,
  });

  static const _backgroundColor = Color(0xFFE3EFFF);

  final String label;
  final Color brandBlue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 500)],
                color: brandBlue,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: brandBlue,
            ),
          ],
        ),
      ),
    );
  }
}
