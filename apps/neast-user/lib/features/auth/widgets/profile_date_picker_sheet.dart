import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/theme/app_colors.dart';

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// 个人资料页英文日期选择（底部弹层 + Cupertino 滚轮）。
Future<DateTime?> showProfileDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  final brandBlue = context.appColors.brandBlue;
  final min = _dateOnly(firstDate);
  final max = _dateOnly(lastDate);
  var selected = _dateOnly(initialDate);

  if (selected.isBefore(min)) {
    selected = min;
  } else if (selected.isAfter(max)) {
    selected = max;
  }

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return Localizations.override(
        context: sheetContext,
        locale: const Locale('en', 'US'),
        child: StatefulBuilder(
          builder: (context, setState) {
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
                            'Select expiry date',
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
                              Navigator.of(sheetContext).pop(selected),
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
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selected,
                      minimumDate: min,
                      maximumDate: max,
                      onDateTimeChanged: (date) {
                        setState(() => selected = _dateOnly(date));
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

/// 英文展示格式，如 31 Dec 2030
String formatProfileDisplayDate(DateTime date) {
  return DateFormat('dd MMM yyyy', 'en_US').format(date);
}
