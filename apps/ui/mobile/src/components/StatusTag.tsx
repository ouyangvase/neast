import { StyleSheet, Text, View, type StyleProp, type TextStyle, type ViewStyle } from 'react-native';

import {
  coreColors,
  merchantAccentColors,
  userAccentColors,
  userHomeColors,
} from '@ui/tokens/colors';
import { radii, spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';

/** Rent/payment history statuses used across the apps. */
export type StatusTagStatus =
  'pending' | 'overdue' | 'paid' | 'settled' | 'cancelled' | 'success' | 'failed' | 'info';

export interface StatusTagProps {
  label: string;
  /** Named status → token-mapped colors. Ignored when `color` is set. */
  status?: StatusTagStatus;
  /** Custom text color (use with `backgroundColor`). */
  color?: string;
  backgroundColor?: string;
  style?: StyleProp<ViewStyle>;
  labelStyle?: StyleProp<TextStyle>;
}

const STATUS_COLORS: Record<StatusTagStatus, { text: string; background: string }> = {
  pending: { text: userAccentColors.pointsDeal, background: userAccentColors.tierBackground },
  overdue: { text: coreColors.error, background: merchantAccentColors.errorBackground },
  paid: { text: coreColors.darkGreen, background: coreColors.tintGreen },
  settled: { text: userHomeColors.navy, background: userHomeColors.lightBlue },
  cancelled: { text: coreColors.textSecondary, background: coreColors.appBarBackground },
  success: { text: coreColors.darkGreen, background: coreColors.tintGreen },
  failed: { text: coreColors.error, background: merchantAccentColors.errorBackground },
  info: { text: userHomeColors.navy, background: userHomeColors.lightBlue },
};

/** Small status pill (rent history rows, transaction rows, …). */
export function StatusTag({
  label,
  status = 'info',
  color,
  backgroundColor,
  style,
  labelStyle,
}: StatusTagProps) {
  const palette = STATUS_COLORS[status];
  return (
    <View style={[styles.tag, { backgroundColor: backgroundColor ?? palette.background }, style]}>
      <Text style={[styles.label, { color: color ?? palette.text }, labelStyle]}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  tag: {
    borderRadius: radii.pill,
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
    alignSelf: 'flex-start',
  },
  label: {
    ...textStyles.caption,
    fontWeight: '600',
  },
});
