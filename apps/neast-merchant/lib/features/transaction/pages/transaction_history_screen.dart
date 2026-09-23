import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';
import 'package:neast/features/transaction/models/transaction_record_model.dart';
import 'package:neast/features/transaction/providers/transaction_list_provider.dart';

/// 交易记录页：顶部品牌图 + Points/Redeemed 切换 + 独立滚动分页列表。
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  static const _backgroundColor = Color(0xFFF2F9FC);
  static const _toggleHeight = 52.0;
  static const _toggleOverlap = 45.0;

  TransactionTab _selectedTab = TransactionTab.points;
  late int _selectedYear = DateTime.now().year;

  List<int> get _years {
    final current = DateTime.now().year;
    return [for (var y = current; y >= current - 5; y--) y];
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.sizeOf(context).width * (635 / 1500);
    final zoneHeight = imageHeight - _toggleOverlap + _toggleHeight;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: zoneHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: NeastBrandHeader(
                    title: const SizedBox.shrink(),
                    fillColor: _backgroundColor,
                    trailing: _YearSelector(
                      year: _selectedYear,
                      years: _years,
                      onSelected: (year) =>
                          setState(() => _selectedYear = year),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: imageHeight - _toggleOverlap,
                  height: _toggleHeight,
                  child: _TabToggle(
                    selected: _selectedTab,
                    onChanged: (tab) => setState(() => _selectedTab = tab),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab.index,
              children: [
                _TransactionList(
                  tab: TransactionTab.points,
                  year: _selectedYear,
                ),
                _TransactionList(
                  tab: TransactionTab.redeemed,
                  year: _selectedYear,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Points / Redeemed 切换按钮。
class _TabToggle extends StatelessWidget {
  const _TabToggle({required this.selected, required this.onChanged});

  static const _selectedColor = Color(0xFF234FA5);

  final TransactionTab selected;
  final ValueChanged<TransactionTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: 'Points',
            selected: selected == TransactionTab.points,
            selectedColor: _selectedColor,
            onTap: () => onChanged(TransactionTab.points),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TabButton(
            label: 'Redeemed',
            selected: selected == TransactionTab.redeemed,
            selectedColor: _selectedColor,
            onTap: () => onChanged(TransactionTab.redeemed),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : selectedColor,
          ),
        ),
      ),
    );
  }
}

/// 单个 Tab 的独立滚动分页列表（下拉刷新 + 上拉加载）。
class _TransactionList extends ConsumerStatefulWidget {
  const _TransactionList({required this.tab, required this.year});

  final TransactionTab tab;
  final int year;

  @override
  ConsumerState<_TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<_TransactionList> {
  late final EasyRefreshController _refreshController;

  TransactionListArg get _arg => (tab: widget.tab, year: widget.year);

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _loadInitial();
  }

  @override
  void didUpdateWidget(covariant _TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year) {
      _loadInitial();
    }
  }

  void _loadInitial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(transactionListProvider(_arg).notifier).initialLoad();
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
    final state = ref.watch(transactionListProvider(_arg));
    final notifier = ref.read(transactionListProvider(_arg).notifier);

    if (state.isLoading && state.list.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.5));
    }

    return AppRefresher(
      controller: _refreshController,
      onRefresh: () => notifier.refresh(),
      onLoad: () async {
        await notifier.loadMore();
        return ref.read(transactionListProvider(_arg)).hasMore;
      },
      child: state.list.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
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
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _RecordTile(record: state.list[index]),
            ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final TransactionRecord record;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  record.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: brandBlue.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
          if (record.pointsLabel != null) ...[
            const SizedBox(width: 12),
            Text(
              record.pointsLabel!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: brandBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 年份筛选胶囊。
class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.year,
    required this.years,
    required this.onSelected,
  });

  final int year;
  final List<int> years;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return PopupMenuButton<int>(
      initialValue: year,
      onSelected: onSelected,
      offset: const Offset(0, 40),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) => [
        for (final y in years)
          PopupMenuItem<int>(
            value: y,
            child: Text(
              '$y',
              style: TextStyle(
                fontSize: 14,
                fontWeight: y == year ? FontWeight.w700 : FontWeight.w500,
                color: brandBlue,
              ),
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 5, 7, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$year',
              style: TextStyle(fontSize: 14, color: brandBlue),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 20, color: brandBlue),
          ],
        ),
      ),
    );
  }
}
