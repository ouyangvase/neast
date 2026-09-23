import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';

/// 发票页：顶部品牌图 + 年份筛选 + 固定 12 个月份列表。
class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late int _selectedYear = DateTime.now().year;

  final _scrollController = ScrollController();
  final _appBarOpacity = ValueNotifier<double>(0);

  /// AppBar 完全显示所需的滚动距离。
  static const _fadeDistance = 90.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _appBarOpacity.dispose();
    super.dispose();
  }

  void _onScroll() {
    _appBarOpacity.value =
        (_scrollController.offset / _fadeDistance).clamp(0.0, 1.0);
  }

  List<int> get _years {
    final current = DateTime.now().year;
    return [for (var y = current; y >= current - 5; y--) y];
  }

  void _onYearSelected(int year) => setState(() => _selectedYear = year);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeastSubpageBackground.color,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NeastBrandHeader(
                  title: const SizedBox.shrink(),
                  fillColor: NeastSubpageBackground.color,
                  trailing: _YearSelector(
                    year: _selectedYear,
                    years: _years,
                    onSelected: _onYearSelected,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final month in _months) ...[
                          _MonthTile(
                            label: month,
                            onTap: () => ToastUtil.show('Please stay tuned.'),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _appBarOpacity,
              builder: (context, opacity, _) {
                return IgnorePointer(
                  ignoring: opacity < 0.5,
                  child: Opacity(
                    opacity: opacity,
                    child: _CollapsedAppBar(
                      title: 'Invoice & Billing',
                      trailing: _YearSelector(
                        year: _selectedYear,
                        years: _years,
                        onSelected: _onYearSelected,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 滚动后淡入的纯色顶栏。
class _CollapsedAppBar extends StatelessWidget {
  const _CollapsedAppBar({
    required this.title,
    required this.trailing,
  });

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Material(
      color: brandBlue,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Positioned(
                left: 4,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 16,
                child: trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 页面背景色（与通用子页保持一致）。
abstract final class NeastSubpageBackground {
  static const color = Color(0xFFF2F9FC);
}

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
        padding: const EdgeInsets.fromLTRB(7, 5, 13, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$year',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'FD',
                fontVariations: [FontVariation('wght', 500)],
                color: brandBlue,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 20, color: brandBlue),
          ],
        ),
      ),
    );
  }
}

class _MonthTile extends StatelessWidget {
  const _MonthTile({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'FD',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: brandBlue.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
