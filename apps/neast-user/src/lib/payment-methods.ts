import { PAYMENT_METHOD_LABELS } from '@neast/constant';
import { FIUU_CHANNELS, PAYMENT_METHODS, type PaymentQuote } from '@neast/types';
import type { PaymentMethod } from '@neast/ui-mobile';

import { feeLabel } from './format';

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
    label: PAYMENT_METHOD_LABELS[id],
    feeLabel: feeLabel(quote, id),
  }));
  if (options.includeWallet) {
    methods.unshift({
      id: 'wallet',
      label: PAYMENT_METHOD_LABELS.wallet,
      description: options.walletBalance ? `Balance RM${options.walletBalance}` : undefined,
      feeLabel: 'No fee',
    });
  }
  return methods;
}
