import type { TextStyle } from 'react-native';

import { coreColors } from './colors';

/**
 * NEAST brand fonts.
 *
 * The Flutter apps declare two variable fonts:
 *  - `FD` = Funnel Display (display numerals / headings)
 *  - `HG` = Host Grotesk (body text)
 *
 * In RN the variable TTFs are registered under these family names via
 * `useBrandFonts()`. NOTE: RN does not expose Flutter's `FontVariation('wght')`;
 * weight is expressed with the regular `fontWeight` style and the variable font
 * is interpolated by the platform where supported (otherwise it renders at the
 * default instance). Presets below carry explicit `fontWeight` so intent is
 * preserved on every platform.
 */
export const fontFamilies = {
  /** Funnel Display — display numerals / headings. */
  display: 'FunnelDisplay',
  /** Host Grotesk — body text. */
  body: 'HostGrotesk',
} as const;

export type FontFamilyToken = keyof typeof fontFamilies;

/** Typed text-style presets. Spread into a `style` prop: `style={textStyles.body}`. */
export const textStyles = {
  /** Large display numeral / hero heading (Funnel Display). */
  displayLarge: {
    fontFamily: fontFamilies.display,
    fontSize: 32,
    lineHeight: 40,
    fontWeight: '700',
    color: coreColors.blackText,
  },
  /** Screen / section heading (Funnel Display). */
  heading1: {
    fontFamily: fontFamilies.display,
    fontSize: 24,
    lineHeight: 32,
    fontWeight: '700',
    color: coreColors.blackText,
  },
  heading2: {
    fontFamily: fontFamilies.display,
    fontSize: 20,
    lineHeight: 28,
    fontWeight: '600',
    color: coreColors.blackText,
  },
  /** Card title (Host Grotesk, semibold). */
  heading3: {
    fontFamily: fontFamilies.body,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '600',
    color: coreColors.blackText,
  },
  /** Default body copy (Host Grotesk). */
  body: {
    fontFamily: fontFamilies.body,
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '400',
    color: coreColors.blackText,
  },
  bodySmall: {
    fontFamily: fontFamilies.body,
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '400',
    color: coreColors.blackText,
  },
  /** Secondary / hint text. */
  caption: {
    fontFamily: fontFamilies.body,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '400',
    color: coreColors.textHint,
  },
  /** Button label. */
  button: {
    fontFamily: fontFamilies.body,
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '600',
    color: coreColors.white,
  },
  /** Display numerals — balances, points (Funnel Display). */
  numeric: {
    fontFamily: fontFamilies.display,
    fontSize: 28,
    lineHeight: 36,
    fontWeight: '700',
    color: coreColors.blackText,
  },
} as const satisfies Record<string, TextStyle>;

export type TextStyleToken = keyof typeof textStyles;
