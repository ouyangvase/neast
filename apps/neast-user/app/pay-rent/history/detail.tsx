import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit } from '@neast/types';
import { Card, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import { payStatusLabel, rentHistoryStatusMeta } from '../../../src/lib/format';
import { useSelectionStore } from '../../../src/stores/selection';
import { ErrorState } from '../../../src/components/StateViews';
import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';
import { PaymentSuccessHero } from '../../../src/features/pay-rent/components';

/** Paid record opened after wallet pay. */
export default function RentHistoryDetailRoute() {
  const entry = useSelectionStore((state) => state.history);

  if (!entry) {
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
        <PaymentSuccessHero
          amount={formatRinggit(entry.amount)}
          period={entry.rental_period}
          status={rentHistoryStatusMeta(entry.status)}
        />

        <Card style={styles.card}>
          <InfoRow label="Rental period" value={entry.rental_period} />
          <InfoRow label="Payment no." value={entry.payment_no} />
          <InfoRow label="Method" value={entry.payment_method!} />
          <InfoRow label="Paid" value={entry.user_paid_at!} />
          <InfoRow label="Timing" value={payStatusLabel(entry.pay_status)} />
          <InfoRow label="Property" value={entry.property_address} />
          <InfoRow label="Owner" value={entry.landlord_account_name} />
        </Card>
      </ScrollView>
    </Screen>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  body: {
    padding: spacing.lg,
    gap: spacing.lg,
  },
  card: {
    gap: spacing.sm,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  infoLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  infoValue: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    flexShrink: 1,
    textAlign: 'right',
  },
});
