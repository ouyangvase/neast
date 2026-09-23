import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 弹出英文年月选择器，返回所选月份（day 固定为 1）。
Future<DateTime?> showRecordMonthPicker({
  required BuildContext context,
  required DateTime initial,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final first = firstDate ?? DateTime(2000);
  final last = lastDate ?? DateTime.now();

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return _RecordMonthPickerSheet(
        initial: DateTime(initial.year, initial.month),
        first: DateTime(first.year, first.month),
        last: DateTime(last.year, last.month),
      );
    },
  );
}

class _RecordMonthPickerSheet extends StatefulWidget {
  const _RecordMonthPickerSheet({
    required this.initial,
    required this.first,
    required this.last,
  });

  final DateTime initial;
  final DateTime first;
  final DateTime last;

  @override
  State<_RecordMonthPickerSheet> createState() =>
      _RecordMonthPickerSheetState();
}

class _RecordMonthPickerSheetState extends State<_RecordMonthPickerSheet> {
  static const _locale = 'en_US';

  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year;
    _month = widget.initial.month;
  }

  bool get _canGoPrevYear => _year > widget.first.year;

  bool get _canGoNextYear => _year < widget.last.year;

  bool _isMonthEnabled(int month) {
    if (_year < widget.first.year || _year > widget.last.year) {
      return false;
    }
    if (_year == widget.first.year && month < widget.first.month) {
      return false;
    }
    if (_year == widget.last.year && month > widget.last.month) {
      return false;
    }
    return true;
  }

  void _selectMonth(int month) {
    if (!_isMonthEnabled(month)) return;
    Navigator.of(context).pop(DateTime(_year, month));
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EFFF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Text(
                  'Select Month',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'HG',
                    fontVariations: const [FontVariation('wght', 600)],
                    color: brandBlue,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: brandBlue.withValues(alpha: 0.6),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _YearNavButton(
                  icon: Icons.chevron_left_rounded,
                  enabled: _canGoPrevYear,
                  color: brandBlue,
                  onTap: () => setState(() => _year--),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    DateFormat('yyyy', _locale).format(DateTime(_year)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'FD',
                      fontVariations: const [FontVariation('wght', 600)],
                      color: brandBlue,
                    ),
                  ),
                ),
                _YearNavButton(
                  icon: Icons.chevron_right_rounded,
                  enabled: _canGoNextYear,
                  color: brandBlue,
                  onTap: () => setState(() => _year++),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.4,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final enabled = _isMonthEnabled(month);
                final selected = _month == month && enabled;

                final label = DateFormat('MMM', _locale)
                    .format(DateTime(_year, month));

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: enabled ? () => _selectMonth(month) : null,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? brandBlue
                            : enabled
                                ? const Color(0xFFF4F8FC)
                                : const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? brandBlue
                              : enabled
                                  ? const Color(0xFFE3EFFF)
                                  : const Color(0xFFEFEFEF),
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'HG',
                          fontVariations: [
                            FontVariation('wght', selected ? 600 : 500),
                          ],
                          color: selected
                              ? Colors.white
                              : enabled
                                  ? brandBlue
                                  : brandBlue.withValues(alpha: 0.28),
                        ),
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

class _YearNavButton extends StatelessWidget {
  const _YearNavButton({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFE3EFFF) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 24,
            color: enabled ? color : color.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}
