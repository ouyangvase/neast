import { Pressable, StyleSheet, View, type StyleProp, type ViewStyle } from 'react-native';
import type { ReactNode } from 'react';

import { coreColors } from '@ui/tokens/colors';
import { cardShadow, radii, spacing } from '@ui/tokens/layout';

export interface CardProps {
  children?: ReactNode;
  style?: StyleProp<ViewStyle>;
  /** Inner padding. Default: true (16). */
  padded?: boolean;
  /** When set, the card becomes pressable. */
  onPress?: () => void;
  /** Drop the elevation-2 shadow. Default: false. */
  flat?: boolean;
}

/** White rounded card — 12px radius, elevation 2 (docs/apps-overview.md §8.1). */
export function Card({ children, style, padded = true, onPress, flat = false }: CardProps) {
  const cardStyle = [styles.card, !flat && cardShadow, padded && styles.padded, style];
  if (onPress) {
    return (
      <Pressable
        accessibilityRole="button"
        onPress={onPress}
        style={({ pressed }) => [...cardStyle, pressed && styles.pressed]}
      >
        {children}
      </Pressable>
    );
  }
  return <View style={cardStyle}>{children}</View>;
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: coreColors.white,
    borderRadius: radii.card,
  },
  padded: {
    padding: spacing.lg,
  },
  pressed: {
    opacity: 0.9,
  },
});
