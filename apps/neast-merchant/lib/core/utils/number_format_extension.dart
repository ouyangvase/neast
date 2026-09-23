/// 为整数添加千分位逗号，如 `4820` → `"4,820"`。
String formatIntegerWithComma(int value) {
  if (value < 0) {
    return '-${formatIntegerWithComma(-value)}';
  }

  return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
}

/// 为金额添加千分位逗号，如 `1245.5` → `"1,245.50"`。
String formatDecimalWithComma(
  num value, {
  int fractionDigits = 2,
}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final intPart = int.tryParse(parts.first) ?? 0;
  final formattedInt = formatIntegerWithComma(intPart);
  if (parts.length == 1) {
    return formattedInt;
  }
  return '$formattedInt.${parts[1]}';
}

extension IntCommaExtension on int {
  String get withComma => formatIntegerWithComma(this);
}

extension NumCommaExtension on num {
  String get decimalWithComma => formatDecimalWithComma(this);
}
