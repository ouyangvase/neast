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

function monthIndex({ year, month }: MonthOption): number {
  return year * 12 + month - 1;
}

function monthFromIndex(index: number): MonthOption {
  return { year: Math.floor(index / 12), month: (index % 12) + 1 };
}

export function currentMonth(): MonthOption {
  const now = new Date();
  return { year: now.getFullYear(), month: now.getMonth() + 1 };
}

export function shiftMonth(value: MonthOption, delta: number): MonthOption {
  return monthFromIndex(monthIndex(value) + delta);
}

function monthRange(from: MonthOption, to: MonthOption): MonthOption[] {
  const result: MonthOption[] = [];
  for (let index = monthIndex(from); index <= monthIndex(to); index += 1) {
    result.push(monthFromIndex(index));
  }
  return result;
}

export function clampMonth(value: MonthOption, months: MonthOption[]): MonthOption {
  const first = months[0] as MonthOption;
  const last = months[months.length - 1] as MonthOption;
  const index = monthIndex(value);
  if (index < monthIndex(first)) return first;
  if (index > monthIndex(last)) return last;
  return value;
}

/** Agreement start: 36 months before the current month through 36 months after. */
export function agreementFromMonths(): MonthOption[] {
  const current = currentMonth();
  return monthRange(shiftMonth(current, -36), shiftMonth(current, 36));
}

/** Agreement end: from max(from, current month), spanning at most 36 Neast payments. */
export function agreementToMonths(agreementFrom: MonthOption): MonthOption[] {
  const current = currentMonth();
  const start = monthIndex(agreementFrom) > monthIndex(current) ? agreementFrom : current;
  return monthRange(start, shiftMonth(start, 35));
}

/** First Neast month: from max(agreement from, current month) through the agreement end. */
export function firstPayMonths(agreementFrom: MonthOption, agreementTo: MonthOption): MonthOption[] {
  const current = currentMonth();
  const start = monthIndex(agreementFrom) > monthIndex(current) ? agreementFrom : current;
  return monthRange(start, agreementTo);
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
