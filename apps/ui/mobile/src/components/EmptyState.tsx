import {
  Image,
  StyleSheet,
  Text,
  View,
  type ImageSourcePropType,
  type StyleProp,
  type TextStyle,
  type ViewStyle,
} from 'react-native';

import { coreColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { Button } from './Button';

export interface EmptyStateProps {
  /** Optional illustration (Metro asset or `{ uri }`). */
  image?: ImageSourcePropType;
  title: string;
  message?: string;
  messageStyle?: StyleProp<TextStyle>;
  /** When both are set, a primary action button is shown. */
  actionLabel?: string;
  onAction?: () => void;
  style?: StyleProp<ViewStyle>;
}

/** Centered empty-list / no-data placeholder. */
export function EmptyState({
  image,
  title,
  message,
  messageStyle,
  actionLabel,
  onAction,
  style,
}: EmptyStateProps) {
  return (
    <View style={[styles.container, style]}>
      {image ? <Image source={image} style={styles.image} resizeMode="contain" /> : null}
      <Text style={styles.title}>{title}</Text>
      {message ? <Text style={[styles.message, messageStyle]}>{message}</Text> : null}
      {actionLabel && onAction ? (
        <Button title={actionLabel} onPress={onAction} fullWidth={false} style={styles.action} />
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  image: {
    width: 120,
    height: 120,
    marginBottom: spacing.lg,
  },
  title: {
    ...textStyles.heading3,
    textAlign: 'center',
  },
  message: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    marginTop: spacing.sm,
  },
  action: {
    marginTop: spacing.lg,
    minWidth: 160,
  },
});
