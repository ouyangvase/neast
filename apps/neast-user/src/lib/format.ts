import { MONTH_NAMES_LONG } from '@neast/constant';
import {
  RENT_HISTORY_STATUS,
  RENT_STATUS,
  type PaymentQuote,
  type RentDueStatus,
} from '@neast/types';
import type { StatusTagStatus } from '@neast/ui-mobile';

export interface StatusMeta {
  label: string;
  tag: StatusTagStatus;
}

/** t_rent.status: 0 pending · 1 approved · 2 rejected · 4 terminated. */
export function rentStatusMeta(status: number): StatusMeta {
  switch (status) {
    case RENT_STATUS.pending:
      return { label: 'Pending', tag: 'pending' };
    case RENT_STATUS.approved:
      return { label: 'Approved', tag: 'success' };
    case RENT_STATUS.rejected:
      return { label: 'Rejected', tag: 'failed' };
    case RENT_STATUS.terminated:
      return { label: 'Terminated', tag: 'cancelled' };
    default:
      return { label: 'Unknown', tag: 'info' };
  }
}

/** Rent history status: 0 pending · 1 paid · 2 settled · 3 cancelled. */
export function rentHistoryStatusMeta(status: number): StatusMeta {
  switch (status) {
    case RENT_HISTORY_STATUS.pending:
      return { label: 'Pending', tag: 'pending' };
    case RENT_HISTORY_STATUS.paid:
      return { label: 'Paid', tag: 'paid' };
    case RENT_HISTORY_STATUS.settled:
      return { label: 'Settled', tag: 'settled' };
    case RENT_HISTORY_STATUS.cancelled:
      return { label: 'Cancelled', tag: 'cancelled' };
    default:
      return { label: 'Unknown', tag: 'info' };
  }
}

/** Topup status: 0 pending · 1 success · 2 failed. */
export function topupStatusMeta(status: number): StatusMeta {
  switch (status) {
    case 0:
      return { label: 'Pending', tag: 'pending' };
    case 1:
      return { label: 'Success', tag: 'success' };
    case 2:
      return { label: 'Failed', tag: 'failed' };
    default:
      return { label: 'Unknown', tag: 'info' };
  }
}

export function payStatusLabel(payStatus: string): string {
  if (payStatus === 'on_time') {
    return 'On time';
  }
  if (payStatus === 'late') {
    return 'Late';
  }
  return 'Upcoming';
}

export function dueStatusLabel(status: RentDueStatus | ''): string {
  switch (status) {
    case 'advance':
      return 'Advance payment';
    case 'due_today':
      return 'Due today';
    case 'overdue':
      return 'Overdue';
    case '':
      return '';
  }
}

/** `1` → `1st`, `22` → `22nd` (rent pay-day picker labels). */
export function ordinalDay(day: number): string {
  const mod100 = day % 100;
  if (mod100 >= 11 && mod100 <= 13) {
    return `${day}th`;
  }
  switch (day % 10) {
    case 1:
      return `${day}st`;
    case 2:
      return `${day}nd`;
    case 3:
      return `${day}rd`;
    default:
      return `${day}th`;
  }
}

/** History year filter chips: current year − 0..9. */
export function yearChips(): number[] {
  const current = new Date().getFullYear();
  return Array.from({ length: 10 }, (_, index) => current - index);
}

export interface MonthOption {
  year: number;
  /** 1–12 */
  month: number;
}

/** Next 12 months starting from the current one (first-pay-month picker). */
export function upcomingMonths(): MonthOption[] {
  const now = new Date();
  const result: MonthOption[] = [];
  let year = now.getFullYear();
  let month = now.getMonth() + 1;
  for (let i = 0; i < 12; i += 1) {
    result.push({ year, month });
    month += 1;
    if (month === 13) {
      month = 1;
      year += 1;
    }
  }
  return result;
}

export function monthOptionLabel({ year, month }: MonthOption): string {
  return `${MONTH_NAMES_LONG[month - 1]} ${year}`;
}

/** `Y-m` wire format for first_pay_month. */
export function monthOptionValue({ year, month }: MonthOption): string {
  return `${year}-${month < 10 ? `0${month}` : month}`;
}

/** Trailing fee label for a payment method row (`+1.6%` / `No fee`). */
export function feeLabel(quote: PaymentQuote | undefined, method: string): string | undefined {
  const methodQuote = quote?.methods?.[method];
  if (!methodQuote) {
    return undefined;
  }
  return methodQuote.fee_percent > 0 ? `+${methodQuote.fee_percent}%` : 'No fee';
}
