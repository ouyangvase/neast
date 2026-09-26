/** Payment methods accepted by topup / rent-pay / settlement order creation. */
export const PAYMENT_METHODS = ['fpx', 'tng', 'grab', 'visa'] as const;
export type PaymentMethod = (typeof PAYMENT_METHODS)[number];
/** Wallet-balance payment (rent pay + settlement pay). */
export const PAYMENT_METHOD_WALLET = 'wallet';

/**
 * Client method id → Fiuu channel (mirrors `config/autoload/fiuu.php`).
 * `fpx` resolves per-bank via `payment_channel`; the others are fixed.
 */
export const FIUU_CHANNELS: Readonly<Record<PaymentMethod, string>> = {
  fpx: 'fpx',
  tng: 'TNG-EWALLET',
  grab: 'GrabPay',
  visa: 'credit',
};

export interface FpxBank {
  /** Display name. */
  name: string;
  /** Fiuu `payment_channel` value (always the payer's bank). */
  channel: string;
}

/** The 17 FPX banks accepted by the backend (`fiuu.fpx_banks`). */
export const FPX_BANKS: readonly FpxBank[] = [
  { name: 'Affin Bank', channel: 'fpx_abb' },
  { name: 'Alliance Bank', channel: 'fpx_abmb' },
  { name: 'AmBank', channel: 'fpx_amb' },
  { name: 'BSN', channel: 'fpx_bsn' },
  { name: 'Bank Islam', channel: 'fpx_bimb' },
  { name: 'Bank Muamalat', channel: 'fpx_bmmb' },
  { name: 'Bank Rakyat', channel: 'fpx_bkrm' },
  { name: 'CIMB Clicks', channel: 'fpx_cimbclicks' },
  { name: 'HSBC Bank', channel: 'fpx_hsbc' },
  { name: 'Hong Leong Bank', channel: 'fpx_hlb' },
  { name: 'KFH', channel: 'fpx_kfh' },
  { name: 'Maybank2U', channel: 'fpx_mb2u' },
  { name: 'OCBC Bank', channel: 'fpx_ocbc' },
  { name: 'Public Bank', channel: 'fpx_pbb' },
  { name: 'RHB Bank', channel: 'fpx_rhb' },
  { name: 'Standard Chartered', channel: 'fpx_scb' },
  { name: 'UOB Bank', channel: 'fpx_uob' },
];

/** wallet_config.dart parity: method id → display label. */
export const PAYMENT_METHOD_LABELS = {
  fpx: 'FPX Online Banking',
  tng: "Touch 'n Go eWallet",
  grab: 'GrabPay',
  visa: 'Credit / Debit Card',
  wallet: 'Wallet Balance',
} as const;
