import { FIUU_CHANNELS, PAYMENT_METHODS, type PaymentQuote } from '@neast/types';
import type { PaymentMethod } from '@neast/ui-mobile';

import { feeLabel } from './format';

/** wallet_config.dart parity: method id → display label (icons not recovered). */
const METHOD_LABELS: Record<string, string> = {
  fpx: 'FPX Online Banking',
  tng: "Touch 'n Go eWallet",
  grab: 'GrabPay',
  visa: 'Credit / Debit Card',
  wallet: 'Wallet Balance',
};

function paymentMethodLabel(id: string): string {
  return METHOD_LABELS[id] ?? id.toUpperCase();
}

/** Fiuu channel for a method; FPX resolves per-bank via the picked channel. */
export function fiuuChannelFor(method: string, fpxChannel?: string): string | undefined {
  if (method === 'fpx') {
    return fpxChannel;
  }
  return (FIUU_CHANNELS as Record<string, string>)[method];
}

/** Build PaymentMethodSection options with quote fee labels. */
export function buildPaymentMethodOptions(
  quote: PaymentQuote | undefined,
  options: { includeWallet?: boolean; walletBalance?: string } = {},
): PaymentMethod[] {
  const methods: PaymentMethod[] = PAYMENT_METHODS.map((id) => ({
    id,
    label: paymentMethodLabel(id),
    feeLabel: feeLabel(quote, id),
  }));
  if (options.includeWallet) {
    methods.unshift({
      id: 'wallet',
      label: paymentMethodLabel('wallet'),
      description: options.walletBalance ? `Balance RM${options.walletBalance}` : undefined,
      feeLabel: 'No fee',
    });
  }
  return methods;
}
