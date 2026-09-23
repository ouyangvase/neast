import {
  Pressable,
  StyleSheet,
  Text,
  View,
  type StyleProp,
  type TextStyle,
  type ViewStyle,
} from 'react-native';
import type { ReactNode } from 'react';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { Chevron } from './Chevron';

export interface BrandHeaderProps {
  /** Plain title (centered, 18pt — matches the Flutter AppBar). */
  title?: string;
  /** Rich title node — takes precedence over `title` (Flutter `neastRichTitle`). */
  richTitle?: ReactNode;
  subtitle?: string;
  /** When set, a back chevron is shown on the left. */
  onBack?: () => void;
  /** Trailing slot (bell, QR button, …). */
  right?: ReactNode;
  backgroundColor?: string;
  style?: StyleProp<ViewStyle>;
  titleStyle?: StyleProp<TextStyle>;
}

/** Brand page header (Flutter `neast_brand_header` equivalent). */
export function BrandHeader({
  title,
  richTitle,
  subtitle,
  onBack,
  right,
  backgroundColor = coreColors.appBarBackground,
  style,
  titleStyle,
}: BrandHeaderProps) {
  return (
    <View style={[styles.container, { backgroundColor }, style]}>
      <View style={styles.side}>
        {onBack ? (
          <Pressable
            onPress={onBack}
            accessibilityRole="button"
            accessibilityLabel="Back"
            hitSlop={12}
            style={styles.back}
          >
            <Chevron direction="left" />
          </Pressable>
        ) : null}
      </View>
      <View style={styles.center}>
        {richTitle ?? (title ? <Text style={[styles.title, titleStyle]}>{title}</Text> : null)}
        {subtitle ? <Text style={styles.subtitle}>{subtitle}</Text> : null}
      </View>
      <View style={[styles.side, styles.right]}>{right}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    minHeight: 56,
    paddingHorizontal: spacing.lg,
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
  },
});
