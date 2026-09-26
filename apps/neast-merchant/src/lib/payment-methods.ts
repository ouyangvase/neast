import { PAYMENT_METHOD_LABELS } from '@neast/constant';
import { FIUU_CHANNELS, PAYMENT_METHODS, PAYMENT_METHOD_WALLET } from '@neast/types';
import type { PaymentMethod } from '@neast/ui-mobile';

/** Fiuu channel for a method; FPX resolves per-bank via the picked channel. */
export function fiuuChannelFor(method: string, fpxChannel?: string): string | undefined {
  if (method === 'fpx') {
    return fpxChannel;
  }
  return (FIUU_CHANNELS as Record<string, string>)[method];
}

/** Fee percent for a method from the /merchant/config processing fees. */
function feePercent(fees: Record<string, number> | undefined, method: string): number {
  return fees?.[method] ?? 0;
}

/** Trailing fee label for a payment method row (`+1.6%` / `No fee`). */
export function feeLabel(fees: Record<string, number> | undefined, method: string): string {
  const percent = feePercent(fees, method);
  return percent > 0 ? `+${percent}%` : 'No fee';
}

/**
 * Charged total for the selected method (display only — the server recomputes
 * the payable amount from the same fee config).
 */
export function totalWithFee(
  amount: string,
  fees: Record<string, number> | undefined,
  method: string,
): string {
  const base = Number(amount);
  if (!Number.isFinite(base)) {
    return amount;
  }
  return (base * (1 + feePercent(fees, method) / 100)).toFixed(2);
}

/** Build PaymentMethodSection options with config fee labels; wallet first when included. */
export function buildPaymentMethodOptions(
  fees: Record<string, number> | undefined,
  options: { includeWallet?: boolean; walletBalance?: string } = {},
): PaymentMethod[] {
  const methods: PaymentMethod[] = PAYMENT_METHODS.map((id) => ({
    id,
    label: PAYMENT_METHOD_LABELS[id],
    feeLabel: feeLabel(fees, id),
  }));
  if (options.includeWallet) {
    methods.unshift({
      id: PAYMENT_METHOD_WALLET,
      label: PAYMENT_METHOD_LABELS.wallet,
      description: options.walletBalance ? `Balance RM${options.walletBalance}` : undefined,
      feeLabel: 'No fee',
    });
  }
  return methods;
}
