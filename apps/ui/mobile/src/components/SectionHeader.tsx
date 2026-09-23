import { Pressable, StyleSheet, Text, View, type StyleProp, type ViewStyle } from 'react-native';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';

export interface SectionHeaderProps {
  title: string;
  /** Trailing action, e.g. "See all". */
  actionLabel?: string;
  onActionPress?: () => void;
  style?: StyleProp<ViewStyle>;
}

/** Section title row with optional trailing action link. */
export function SectionHeader({ title, actionLabel, onActionPress, style }: SectionHeaderProps) {
  return (
    <View style={[styles.row, style]}>
      <Text style={styles.title}>{title}</Text>
      {actionLabel ? (
        <Pressable onPress={onActionPress} accessibilityRole="button" hitSlop={8}>
          <Text style={styles.action}>{actionLabel}</Text>
        </Pressable>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.lg,
    marginBottom: spacing.md,
  },
  title: {
    ...textStyles.heading3,
  },
  action: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '500',
  },
});
