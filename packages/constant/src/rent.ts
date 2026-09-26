/** Lease length chips on the add-tenancy form. */
export const LEASE_MONTH_OPTIONS = [3, 6, 12, 18, 24, 36] as const;

/** Due-day chips: 1–31. */
export const DAY_OPTIONS = Array.from({ length: 31 }, (_, index) => index + 1);
