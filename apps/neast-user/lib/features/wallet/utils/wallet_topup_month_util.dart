const walletTopupMonthLabels = [
  'Jan.',
  'Feb.',
  'Mar.',
  'Apr.',
  'May.',
  'Jun.',
  'Jul.',
  'Aug.',
  'Sep.',
  'Oct.',
  'Nov.',
  'Dec.',
];

/// 近 12 个自然月（含当月，倒序）。
List<DateTime> rollingWalletTopupMonths({DateTime? anchor}) {
  final now = anchor ?? DateTime.now();
  final current = DateTime(now.year, now.month);

  return List.generate(12, (index) {
    return DateTime(current.year, current.month - index);
  });
}

String formatWalletTopupMonthLabel(DateTime month) {
  final normalized = DateTime(month.year, month.month);
  final label = walletTopupMonthLabels[normalized.month - 1];
  final currentYear = DateTime.now().year;

  if (normalized.year == currentYear) {
    return label;
  }

  return '$label ${normalized.year}';
}
