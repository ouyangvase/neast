import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// Pay Rent 交租日选择（每月 1-31 日）。
Future<int?> showPayRentDayPicker({
  required BuildContext context,
  int? initialDay,
}) {
  final brandBlue = context.appColors.brandBlue;
  var selected = initialDay ?? 1;
  if (selected < 1) selected = 1;
  if (selected > 31) selected = 31;

  return showModalBottomSheet<int>(
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
                      'Select pay date',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(selected),
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
                  initialItem: selected - 1,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) => selected = index + 1,
                children: List.generate(
                  31,
                  (index) => Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        color: brandBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

String formatPayDayLabel(int day) {
  return 'Day $day';
}
