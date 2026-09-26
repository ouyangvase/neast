import { ActivityIndicator, StyleSheet, View } from 'react-native';

import { EmptyState, Skeleton, spacing, userHomeColors } from '@neast/ui-mobile';

/** Centered spinner for first-load states. */
export function LoadingState() {
  return (
    <View style={styles.center}>
      <ActivityIndicator size="large" color={userHomeColors.emptyGrey} />
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

/** Pulsing card placeholders (coupon/merchant list skeletons). */
export function ListSkeleton({ rows }: { rows: number }) {
  return (
    <View style={styles.skeletons}>
      {Array.from({ length: rows }, (_, index) => (
        <Skeleton key={index} height={96} radius={12} style={styles.skeletonRow} />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  center: {
    flexGrow: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  skeletons: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  skeletonRow: {
    alignSelf: 'stretch',
  },
});
