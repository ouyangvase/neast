/**
 * Display formatters ported from the Flutter apps (`date_format_utils.dart`,
 * `price_extension.dart`). Hermes ships without full ICU, so grouping and
 * month names are done manually — no `Intl` / `toLocaleString` here.
 */

const MONTH_NAMES_SHORT = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
] as const;

const MONTH_NAMES_LONG = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
] as const;

/**
 * Parse the backend's date strings into a `Date`.
 * Handles `Y-m-d H:i:s` (treated as local time, like the Flutter apps),
 * `Y-m-d` (local midnight), and ISO strings. Returns `null` when unparseable.
 */
export function toDate(value: string | number | null | undefined): Date | null {
  if (value === null || value === undefined || value === '') {
    return null;
  }
  if (typeof value === 'number') {
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? null : date;
  }
  const mysql = /^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})(?::(\d{2}))?$/.exec(value);
  if (mysql) {
    const [, y, mo, d, h, mi, s] = mysql;
    return new Date(Number(y), Number(mo) - 1, Number(d), Number(h), Number(mi), s ? Number(s) : 0);
  }
  const dateOnly = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
  if (dateOnly) {
    const [, y, mo, d] = dateOnly;
    return new Date(Number(y), Number(mo) - 1, Number(d));
  }
  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime()) ? null : parsed;
}

function pad2(n: number): string {
  return n < 10 ? `0${n}` : String(n);
}

/** Thousands separator for the integer part; decimals are preserved (`5400.5` → `5,400.5`). */
export function formatThousands(value: number | string): string {
  const raw = String(value).trim();
  const negative = raw.startsWith('-');
  const unsigned = negative ? raw.slice(1) : raw;
  const dotIndex = unsigned.indexOf('.');
  const intPart = dotIndex === -1 ? unsigned : unsigned.slice(0, dotIndex);
  const fracPart = dotIndex === -1 ? '' : unsigned.slice(dotIndex);
  const grouped = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  return `${negative ? '-' : ''}${grouped}${fracPart}`;
}

/** `5400` → `RM5,400.00`. Pass `decimals: 0` for whole-ringgit displays. */
export function formatRinggit(
  amount: number | string,
  options: { decimals?: number; symbol?: string } = {},
): string {
  const { decimals = 2, symbol = 'RM' } = options;
  const numeric = typeof amount === 'number' ? amount : Number(amount);
  if (!Number.isFinite(numeric)) {
    return `${symbol}${amount}`;
  }
  return `${symbol}${formatThousands(numeric.toFixed(decimals))}`;
}

/** `1 Oct 2026` (matches the backend's `d M Y` log dates). */
export function formatSimpleDate(value: string | number | Date | null | undefined): string {
  const date = value instanceof Date ? value : toDate(value);
  if (!date) {
    return '';
  }
  return `${date.getDate()} ${MONTH_NAMES_SHORT[date.getMonth()]} ${date.getFullYear()}`;
}

/** `Oct 2026` (tent-score "since", settlement bill months). */
export function formatMonthYear(value: string | number | Date | null | undefined): string {
  const date = value instanceof Date ? value : toDate(value);
  if (!date) {
    return '';
  }
  return `${MONTH_NAMES_SHORT[date.getMonth()]} ${date.getFullYear()}`;
}

function ordinalSuffix(day: number): string {
  const mod100 = day % 100;
  if (mod100 >= 11 && mod100 <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

/** `At 3:30 pm on March 15th, 2025` (message detail timestamps). */
export function formatReadableDateTime(value: string | number | Date | null | undefined): string {
  const date = value instanceof Date ? value : toDate(value);
  if (!date) {
    return '';
  }
  const hours = date.getHours();
  const hour12 = hours % 12 === 0 ? 12 : hours % 12;
  const ampm = hours < 12 ? 'am' : 'pm';
  const day = date.getDate();
  return `At ${hour12}:${pad2(date.getMinutes())} ${ampm} on ${MONTH_NAMES_LONG[date.getMonth()]} ${day}${ordinalSuffix(day)}, ${date.getFullYear()}`;
}

/** Relative time ("just now", "5 minutes ago", …) for message lists. */
export function formatRelativeTime(
  value: string | number | Date | null | undefined,
  now: Date = new Date(),
): string {
  const date = value instanceof Date ? value : toDate(value);
  if (!date) {
    return '';
  }
  const diffSeconds = Math.floor((now.getTime() - date.getTime()) / 1000);
  if (diffSeconds < 60) {
    return 'just now';
  }
  const diffMinutes = Math.floor(diffSeconds / 60);
  if (diffMinutes < 60) {
    return `${diffMinutes} minute${diffMinutes === 1 ? '' : 's'} ago`;
  }
  const diffHours = Math.floor(diffMinutes / 60);
  if (diffHours < 24) {
    return `${diffHours} hour${diffHours === 1 ? '' : 's'} ago`;
  }
  const diffDays = Math.floor(diffHours / 24);
  if (diffDays < 30) {
    return `${diffDays} day${diffDays === 1 ? '' : 's'} ago`;
  }
  return formatSimpleDate(date);
}

/** Strip everything except digits (`+60 12-345 6789` → `60123456789`). */
export function normalizePhoneDigits(value: string): string {
  return value.replace(/\D/g, '');
}

/**
 * Build the login `account` from the country-code picker and the phone input
 * (`fullPhoneAccount = dial + digits` in the Flutter login provider).
 */
export function joinPhoneAccount(countryCode: string, phone: string): string {
  return `${normalizePhoneDigits(countryCode)}${normalizePhoneDigits(phone)}`;
}
