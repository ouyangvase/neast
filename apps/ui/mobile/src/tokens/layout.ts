/**
 * NEAST design tokens — radii, spacing, shadows.
 * Source: docs/apps-overview.md §8.1 "Chrome & layout".
 */

export const radii = {
  /** ElevatedButton corner radius. */
  button: 8,
  /** Card corner radius. */
  card: 12,
  /** Small pills / tags. */
  pill: 999,
} as const;

export const spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  xxl: 32,
} as const;

/** Card shadow — matches Flutter `elevation: 2` cards. */
export const cardShadow = {
  shadowColor: '#000000',
  shadowOffset: { width: 0, height: 1 },
  shadowOpacity: 0.1,
  shadowRadius: 3,
  elevation: 2,
} as const;
