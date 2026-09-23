import { formatMonthYear } from '@neast/types';
import type { StatusTagStatus } from '@neast/ui-mobile';

export interface StatusMeta {
  label: string;
  tag: StatusTagStatus;
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

/** History year filter chips: current year − 0..9. */
export function yearChips(): number[] {
  const current = new Date().getFullYear();
  return Array.from({ length: 10 }, (_, index) => current - index);
}

/**
 * Settlement due date (client-computed, apps-overview §6.2): the 10th of the
 * month after `bill_month` (`Y-m`). `new Date(y, m, 1)` with the 1-based bill
 * month lands on the following month.
 */
export function settlementDueLabel(billMonth: string): string {
  const match = /^(\d{4})-(\d{2})$/.exec(billMonth);
  if (!match) {
    return '';
  }
  const due = new Date(Number(match[1]), Number(match[2]), 1);
  return `10 ${formatMonthYear(due)}`;
}
