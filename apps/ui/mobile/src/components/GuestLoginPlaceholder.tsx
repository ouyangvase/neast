import {
  Image,
  StyleSheet,
  Text,
  type ImageSourcePropType,
  type StyleProp,
  type ViewStyle,
} from 'react-native';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { Button } from './Button';
import { Card } from './Card';

export interface GuestLoginPlaceholderProps {
  /** Shown to logged-out users on gated tabs (wallet, rent pay, points, …). */
  onLoginPress: () => void;
  title?: string;
  message?: string;
  loginLabel?: string;
  image?: ImageSourcePropType;
  style?: StyleProp<ViewStyle>;
}

/** Login CTA card shown in place of content that requires an account. */
export function GuestLoginPlaceholder({
  onLoginPress,
  title = 'Log in to continue',
  message = 'This feature is available to logged-in users.',
  loginLabel = 'Log in',
  image,
  style,
}: GuestLoginPlaceholderProps) {
  return (
    <Card style={[styles.card, style]}>
      {image ? <Image source={image} style={styles.image} resizeMode="contain" /> : null}
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.message}>{message}</Text>
      <Button title={loginLabel} onPress={onLoginPress} fullWidth={false} style={styles.button} />
    </Card>
  );
}

const styles = StyleSheet.create({
  card: {
    alignItems: 'center',
  },
  image: {
    width: 96,
    height: 96,
    marginBottom: spacing.md,
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
  button: {
    marginTop: spacing.lg,
    minWidth: 160,
  },
});
