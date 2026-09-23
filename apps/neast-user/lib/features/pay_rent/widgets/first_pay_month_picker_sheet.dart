import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/utils/first_pay_month_util.dart';

/// 首次交租月份选择（当月 / 下月，取决于交租日）。
Future<DateTime?> showFirstPayMonthPicker({
  required BuildContext context,
  required int payDay,
  DateTime? initialMonth,
}) {
  final options = availableFirstPayMonths(payDay: payDay);
  if (options.isEmpty) {
    return Future.value();
  }

  final brandBlue = context.appColors.brandBlue;
  var selectedIndex = 0;
  if (initialMonth != null) {
    final index = options.indexWhere(
      (month) =>
          month.year == initialMonth.year && month.month == initialMonth.month,
    );
    if (index >= 0) {
      selectedIndex = index;
    }
  }

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: brandBlue.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Select first pay month',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(sheetContext).pop(options[selectedIndex]),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedIndex,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: [
                  for (final month in options)
                    Center(
                      child: Text(
                        formatFirstPayMonthLabel(month),
                        style: TextStyle(
                          fontSize: 20,
                          color: brandBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
