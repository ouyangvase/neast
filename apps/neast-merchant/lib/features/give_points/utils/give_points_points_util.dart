/// 积分与金额换算。
abstract final class GivePointsPointsUtil {
  static int pointsFromAmount(String amountText, int yuanToPoints) {
    final amount = double.tryParse(amountText.replaceAll(',', '').trim()) ?? 0;
    if (yuanToPoints <= 0) {
      return 0;
    }
    return (amount * yuanToPoints).round();
  }

  static String formatAmountDisplay(String amountText) {
    final amount = double.tryParse(amountText.replaceAll(',', '').trim());
    if (amount == null) {
      return amountText.isEmpty ? '0.00' : amountText;
    }
    return amount.toStringAsFixed(2);
  }
}
