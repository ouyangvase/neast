import type { TextStyle } from 'react-native';

import { coreColors } from './colors';

/** Typed text-style presets. Spread into a `style` prop: `style={textStyles.body}`. */
export const textStyles = {
  /** Large display numeral / hero heading. */
  displayLarge: {
    fontSize: 32,
    lineHeight: 40,
    fontWeight: '700',
    color: coreColors.blackText,
  },
  /** Screen / section heading. */
  heading1: {
    fontSize: 24,
    lineHeight: 32,
    fontWeight: '700',
    color: coreColors.blackText,
  },
  heading2: {
    fontSize: 20,
    lineHeight: 28,
    fontWeight: '600',
    color: coreColors.blackText,
  },
  /** Card title. */
  heading3: {
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '600',
    color: coreColors.blackText,
  },
  /** Default body copy. */
  body: {
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '400',
    color: coreColors.blackText,
  },
  bodySmall: {
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '400',
    color: coreColors.blackText,
  },
  /** Secondary / hint text. */
  caption: {
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '400',
    color: coreColors.textHint,
  },
  /** Button label. */
  button: {
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '600',
    color: coreColors.white,
  },
  /** Display numerals — balances, points. */
  numeric: {
    fontSize: 28,
    lineHeight: 36,
    fontWeight: '700',
    color: coreColors.blackText,
  },
} as const satisfies Record<string, TextStyle>;

export type TextStyleToken = keyof typeof textStyles;
