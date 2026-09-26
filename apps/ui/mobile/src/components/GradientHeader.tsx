import { LinearGradient } from 'expo-linear-gradient';
import type { ReactNode } from 'react';
import {
  Pressable,
  StyleSheet,
  Text,
  View,
  type StyleProp,
  type TextStyle,
  type ViewStyle,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { coreColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { Chevron } from './Chevron';

export interface GradientHeaderProps {
  /** Gradient colors, e.g. `theme.gradients.header` (owner blue / merchant corporate blue). */
  colors: readonly [string, string, ...string[]];
  title?: string;
  subtitle?: string;
  onBack?: () => void;
  /** Trailing slot. */
  right?: ReactNode;
  /** Extra content rendered below the title row (stats, search, …). */
  children?: ReactNode;
  /** Light text/icons (for dark gradients). Default: true. */
  lightContent?: boolean;
  style?: StyleProp<ViewStyle>;
  titleStyle?: StyleProp<TextStyle>;
}

/**
 * Gradient page header (owner records/ack/portfolio headers, merchant scan
 * header, login headers). The gradient bleeds under the status bar; content
 * sits below the safe-area inset.
 */
export function GradientHeader({
  colors,
  title,
  subtitle,
  onBack,
  right,
  children,
  lightContent = true,
  style,
  titleStyle,
}: GradientHeaderProps) {
  const insets = useSafeAreaInsets();
  const contentColor = lightContent ? coreColors.white : coreColors.blackText;
  return (
    <LinearGradient
      colors={colors}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={[styles.gradient, { paddingTop: insets.top + spacing.sm }, style]}
    >
      <View style={styles.row}>
        <View style={styles.side}>
          {onBack ? (
            <Pressable
              onPress={onBack}
              accessibilityRole="button"
              accessibilityLabel="Back"
              hitSlop={12}
              style={styles.back}
            >
              <Chevron direction="left" color={contentColor} />
            </Pressable>
          ) : null}
        </View>
        <View style={styles.center}>
          {title ? (
            <Text style={[styles.title, { color: contentColor }, titleStyle]}>{title}</Text>
          ) : null}
          {subtitle ? (
            <Text style={[styles.subtitle, { color: contentColor }]}>{subtitle}</Text>
          ) : null}
        </View>
        <View style={[styles.side, styles.right]}>{right}</View>
      </View>
      {children}
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  gradient: {
    paddingBottom: spacing.lg,
    paddingHorizontal: spacing.lg,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    minHeight: 44,
  },
  side: {
    minWidth: 40,
    alignItems: 'flex-start',
  },
  right: {
    alignItems: 'flex-end',
  },
  back: {
    padding: spacing.xs,
  },
  center: {
    flex: 1,
    alignItems: 'center',
  },
  title: {
    ...textStyles.heading3,
    fontSize: 18,
    textAlign: 'center',
  },
  subtitle: {
    ...textStyles.caption,
    textAlign: 'center',
    marginTop: 2,
    opacity: 0.85,
  },
});
