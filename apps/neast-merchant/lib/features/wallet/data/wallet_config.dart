/// 钱包页图片资源。
abstract final class WalletAssets {
  static const balanceIcon = 'assets/images/wallet/balance-icon.png';
  static const paymentSuccess = 'assets/images/wallet/payment-success.png';
}

/// 支付方式数据模型。
class PaymentMethodItem {
  const PaymentMethodItem({
    required this.id,
    required this.label,
    this.trailing,
    this.totalAmountLabel,
  });

  final String id;
  final String label;
  final String? trailing;
  final String? totalAmountLabel;
}

/// 钱包页静态配置。
abstract final class WalletConfig {
  static const presetAmounts = [500, 1000, 1500, 2000];

  static const topupPaymentMethods = [
    PaymentMethodItem(id: 'fpx', label: 'FPX'),
    PaymentMethodItem(id: 'tng', label: 'TNG'),
    PaymentMethodItem(id: 'grab', label: 'GRAB'),
    PaymentMethodItem(id: 'visa', label: 'Visa/Master'),
  ];

  static const allPaymentMethods = [
    ...topupPaymentMethods,
    PaymentMethodItem(
      id: 'wallet',
      label: 'Wallet',
      trailing: 'Remaining: RM3000',
    ),
  ];

  static const defaultPaymentMethodId = 'fpx';
}

/// 格式化支付方式手续费展示文案。
String formatProcessingFeeLabel(double feePercent) {
  if (feePercent <= 0) {
    return 'No additional charges';
  }

  final text = feePercent == feePercent.roundToDouble()
      ? feePercent.toInt().toString()
      : feePercent.toString();
  return '$text% processing fee';
}

/// 格式化支付金额展示（带 RM 前缀与千分位）。
String formatPaymentAmountDisplay(String amount) {
  return 'RM ${formatAmountWithThousandsSeparator(amount)}';
}

/// 格式化金额千分位（不含 RM 前缀）。
String formatAmountWithThousandsSeparator(String amount) {
  final value = double.tryParse(amount);
  if (value == null) return amount;

  final formatted = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  return _addThousandsSeparator(formatted);
}

String _addThousandsSeparator(String text) {
  final parts = text.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  if (parts.length == 1) return intPart;
  return '$intPart.${parts[1]}';
}

String formatTotalAmountWithFee(double amount, double feePercent) {
  final total = (amount * (1 + feePercent / 100));
  return formatPaymentAmountDisplay(total.toStringAsFixed(2));
}
