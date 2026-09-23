import { ActivityIndicator, StyleSheet, View } from 'react-native';

import { coreColors, EmptyState, spacing } from '@neast/ui-mobile';

/** Centered spinner for first-load states. */
export function LoadingState() {
  return (
    <View style={styles.center}>
      <ActivityIndicator size="large" color={coreColors.actionGreen} />
    </View>
  );
}

/** Error + retry placeholder. */
export function ErrorState({ message, onRetry }: { message?: string; onRetry?: () => void }) {
  return (
    <EmptyState
      title="Something went wrong"
      message={message ?? 'Please try again.'}
      actionLabel={onRetry ? 'Retry' : undefined}
      onAction={onRetry}
      style={styles.center}
    />
  );
}

const styles = StyleSheet.create({
  center: {
    flexGrow: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
});
