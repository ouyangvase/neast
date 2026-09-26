import { ScrollView, StyleSheet } from 'react-native';
import { router } from 'expo-router';

import { spacing } from '@neast/ui-mobile';

import { useSelectionStore } from '@/stores/selection';
import { ErrorState } from '@/components/StateViews';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';
import { PaymentReceipt } from '@/features/pay-rent/receipt';

/** Payment record opened from Recent payments, with a local PDF receipt. */
export default function RecentPaymentDetailRoute() {
  const rent = useSelectionStore((state) => state.rent);
  const entry = useSelectionStore((state) => state.history);

  if (!rent || !entry) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Payment" />
        <ErrorState message="Payment record unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  return (
    <Screen edges={[]}>
      <PageHeader title="Payment" />
      <ScrollView contentContainerStyle={styles.body}>
        <PaymentReceipt rent={rent} entry={entry} />
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    padding: spacing.lg,
    gap: spacing.lg,
  },
});
