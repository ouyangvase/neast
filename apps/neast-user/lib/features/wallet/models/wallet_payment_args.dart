class WalletPaymentArgs {
  const WalletPaymentArgs({
    required this.amount,
    required this.amountLabel,
  });

  final double amount;
  final String amountLabel;
}
