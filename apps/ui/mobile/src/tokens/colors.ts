/**
 * NEAST design tokens — colors.
 * Source of truth: docs/apps-overview.md §8 (verified against the Flutter apps'
 * lib/core/theme/app_colors.dart + app_theme.dart and recurring hardcoded hexes).
 */

/** Core palette — identical in all three apps. */
export const coreColors = {
  /** Brand headers, primary text accents. */
  brandBlue: '#0851AA',
  /** Secondary brand accents, selected states. */
  brandBlueLight: '#234FA5',
  /** Light green accent. Action buttons use `userHomeColors.navy`. */
  actionGreen: '#4ADB77',
  /** Success / paid / positive money states. */
  darkGreen: '#3EBF7A',
  /** Primary text (dark slate, not pure black). */
  blackText: '#0F172A',
  /** Error / overdue / destructive. */
  error: '#FF4444',

  // Secondary / hint text
  textSecondary: '#666666',
  textHint: '#999999',

  // Borders / dividers
  border: '#D0D5DD',
  borderLight: '#E5E7EB',
  divider: '#E8ECF0',

  // Tinted card / section backgrounds
  tintGreen: '#F6F9F6',
  tintBlue: '#F8FBFF',

  // Chrome & layout (from app_theme.dart)
  appBarBackground: '#F5F5F5',
  tabSelected: '#0F172A',
  tabUnselected: '#B0B0B0',

  white: '#FFFFFF',
  black: '#000000',
  /** iOS splash background for the user and merchant apps. */
  splashBlue: '#4A78BD',
} as const;

export type CoreColorToken = keyof typeof coreColors;

/** neast-user accents — brand blue + gold loyalty tier. */
export const userAccentColors = {
  /** "Earn points" chips on rent cards, rent-file/status accents. */
  gold: '#D4A853',
  /** Points-deal accent on the merchant map (vs blue for regular deals). */
  pointsDeal: '#B8860B',
  /** Reward-tier card text. */
  tierText: '#895A1B',
  /** Reward-tier card background. */
  tierBackground: '#FBF6DA',
  /** Section background (home). */
  sectionBackgroundAlt: '#F8FBFF',
} as const;

/**
 * neast-user home palette — mirrors the tenant web app home
 * (NEAST-source apps/neast `app/index.tsx` + `src/tenant-ui.tsx`).
 */
export const userHomeColors = {
  /** Home backdrop, journey + property promos. */
  navy: '#00135C',
  /** Home header. */
  deepBlue: '#031B58',
  /** Primary buttons, links, icons. */
  royalBlue: '#0738B8',
  /** Tile artwork background. */
  lightBlue: '#EEF4FF',
  /** Gold accents on navy (AmountCard eyebrow, highlights). */
  gold: '#F4C247',
  /** AmountCard background. */
  cream: '#FFF2D3',
  lightCream: '#FFF9EA',
  /** Screen background. */
  background: '#F5F6F9',
  /** Card surfaces. */
  surface: '#FFFFFF',
  textPrimary: '#111827',
  textSecondary: '#64758A',
  border: '#E5E9F2',
  /** Campaign card background. */
  campaignBlue: '#092C83',
  /** Notification badge. */
  badgeRed: '#DA2535',
  /** Light-blue text on navy, strongest. */
  textOnNavy: '#E3EBFF',
  /** Light-blue text on navy, secondary. */
  textOnNavyAlt: '#D8E3FF',
  /** Light-blue text on navy, softest. */
  textOnNavyMuted: '#C7D8FF',
  /** Rent-month house icon when the period is upcoming. */
  upcomingBlue: '#A7C4F5',
  /** Muted grey for an empty rent month and a linked-owner button. */
  emptyGrey: '#9CA3AF',
} as const;

/** neast-owner accents — soft blue gradients + warm tan highlights. */
export const ownerAccentColors = {
  /** Blue gradient headers: records list, ack list, portfolio snapshot, month picker. */
  gradientBlueStart: '#E3EFFF',
  gradientBlueEnd: '#79A1D3',
  /** Warm gradient highlight cards. */
  gradientWarmStart: '#FFF8EC',
  gradientWarmEnd: '#ECB87D',
  /** Orange accent (overdue/attention). */
  orange: '#DF4700',
  /** Tan accent on stats. */
  tan: '#E3A86D',
  /** Blue-tinted surfaces. */
  surfaceBlue: '#E8F0F8',
  surfaceBlueAlt: '#ECF4FF',
  surfaceBlueLight: '#EAF2FA',
  surfaceCyan: '#F2F9FC',
  /** Muted blue icons/labels. */
  mutedBlue: '#ACC4E5',
} as const;

/** neast-merchant accents — corporate blue gradients. */
export const merchantAccentColors = {
  /** Scan-tab header gradient. */
  gradientScanStart: '#4A97D4',
  gradientScanEnd: '#006EC0',
  /** Give-points customer card gradient. */
  gradientCardStart: '#234FA5',
  gradientCardEnd: '#4A82EF',
  /** Selected filter/tab state (transaction history). */
  selected: '#234FA5',
  /** Gold highlights (points, settlement accents). */
  gold: '#E3A86D',
  goldBright: '#F5C842',
  /** Error / failed-transaction row background (text is core `error`). */
  errorBackground: '#FDECEC',
  /** Blue-tinted surfaces. */
  surfaceCyan: '#F2F9FC',
  surfaceBlue: '#EBF4FD',
  surfaceBlueLight: '#E3EFFF',
} as const;

export type UserAccentToken = keyof typeof userAccentColors;
export type UserHomeColorToken = keyof typeof userHomeColors;
export type OwnerAccentToken = keyof typeof ownerAccentColors;
export type MerchantAccentToken = keyof typeof merchantAccentColors;
