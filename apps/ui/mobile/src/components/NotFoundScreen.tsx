import { StyleSheet, Text, View } from 'react-native';

import type { AppId } from '@ui/tokens/themes';

import { coreColors, merchantAccentColors, userHomeColors } from '@ui/tokens/colors';
import { spacing } from '@ui/tokens/layout';
import { textStyles } from '@ui/tokens/typography';
import { Button } from './Button';

const actionColor: Record<AppId, string> = {
  user: userHomeColors.royalBlue,
  owner: coreColors.brandBlue,
  merchant: merchantAccentColors.selected,
};

export interface NotFoundScreenProps {
  /** Which app is showing the page — selects that app's action color. */
  app: AppId;
  onHome: () => void;
}

/** Unmatched-route page shared by the user, owner, and merchant apps. */
export function NotFoundScreen({ app, onHome }: NotFoundScreenProps) {
  const user = app === 'user';
  return (
    <View style={[styles.container, user && styles.userContainer]}>
      <Text style={[styles.title, user && styles.userTitle]}>Page not found</Text>
      <Text style={[styles.message, user && styles.userMessage]}>
        The page you are looking for does not exist.
      </Text>
      <Button
        title="Back to Home"
        variant="secondary"
        fullWidth={false}
        onPress={onHome}
        style={[styles.action, { backgroundColor: actionColor[app] }]}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: coreColors.white,
    padding: spacing.xl,
    gap: spacing.md,
  },
  userContainer: {
    backgroundColor: userHomeColors.background,
  },
  title: {
    ...textStyles.heading2,
  },
  userTitle: {
    color: userHomeColors.textPrimary,
  },
  message: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
  },
  userMessage: {
    color: userHomeColors.textSecondary,
  },
  action: {
    minWidth: 160,
  },
});
