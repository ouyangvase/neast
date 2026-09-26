export const MONTH_NAMES_SHORT = [
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

export const MONTH_NAMES_LONG = [
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

/** `october` → 10. Built from the long names so the two lists cannot drift. */
export const MONTH_INDEX: Record<string, number> = Object.fromEntries(
  MONTH_NAMES_LONG.map((name, index) => [name.toLowerCase(), index + 1]),
);
