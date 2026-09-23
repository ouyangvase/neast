/// Settlement 页面静态文案。
abstract final class SettlementConstants {
  static const howChargesItems = [
    '10% platform fee on points issued',
    'Settled monthly · paid by 10th',
    'Auto-deduct from ewallet if enabled',
  ];
}

/// 支付方式。
enum SettlementPaymentMethod {
  fpx('FPX'),
  tng('TNG'),
  grab('GRAB'),
  visaMaster('Visa/Master'),
  wallet('Wallet');

  const SettlementPaymentMethod(this.label);

  final String label;

  String get apiId => switch (this) {
        SettlementPaymentMethod.visaMaster => 'visa',
        _ => name,
      };
}
