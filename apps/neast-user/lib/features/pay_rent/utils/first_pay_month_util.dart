const _shortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

bool _isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// 根据交租日计算可选首次交租月份（均为当月 1 号）。
List<DateTime> availableFirstPayMonths({
  required int payDay,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final currentMonth = _monthStart(today);
  final nextMonth = DateTime(today.year, today.month + 1);

  if (payDay > today.day) {
    return [currentMonth, nextMonth];
  }

  return [nextMonth];
}

/// 展示文案：Jul 2026
String formatFirstPayMonthLabel(DateTime month) {
  return '${_shortMonths[month.month - 1]} ${month.year}';
}

/// API 提交格式：2026-07
String formatFirstPayMonthValue(DateTime month) {
  final monthText = month.month.toString().padLeft(2, '0');
  return '${month.year}-$monthText';
}

bool isFirstPayMonthAvailable({
  required DateTime month,
  required int payDay,
  DateTime? now,
}) {
  return availableFirstPayMonths(payDay: payDay, now: now).any(
    (candidate) => _isSameMonth(candidate, month),
  );
}
