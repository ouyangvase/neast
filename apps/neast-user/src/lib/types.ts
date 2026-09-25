import type { RentHistoryStatus, RentPayStatus } from '@neast/types';

/**
 * Rent history row. The real API returns `RentHistoryItem`; the dev mock
 * returns the Flutter-shaped row (with `user_paid_at`, `payout_status`, …).
 * This superset tolerates both — mock-only extras are optional.
 */
export interface RentHistoryEntry {
  id: number;
  rent_id: number;
  amount: string;
  status: RentHistoryStatus;
  payment_method: string | null;
  payment_no: string;
  rental_period: string;
  pay_status: RentPayStatus;
  display_status: RentPayStatus;
  landlord_account_name: string;
  property_address: string;
  user_id?: number;
  paid_at?: string | null;
  created_at?: string;
  last_paid_date: string;
  /** mock-only */
  user_paid_at?: string;
  /** mock-only: '' | 'queued' | 'held' | 'invited' */
  payout_status?: string;
  /** mock-only */
  landlord_name?: string;
  /** mock-only */
  landlord_id?: number | null;
  /** mock-only */
  landlord_bank_last4?: string;
}

/** Flutter `isPaidDetailAvailable`: history detail is viewable once paid/settled. */
export function isPaidHistory(entry: RentHistoryEntry): boolean {
  return entry.status === 1 || entry.status === 2;
}
