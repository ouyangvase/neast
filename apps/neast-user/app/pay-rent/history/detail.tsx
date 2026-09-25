import { StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  spacing,
  StatusTag,
  textStyles,
} from '@neast/ui-mobile';

import SuccessArt from '../../../assets/images/pay_rent/success.svg';

import { payStatusLabel, rentHistoryStatusMeta } from '../../../src/lib/format';
import { useSelectionStore } from '../../../src/stores/selection';
import { ErrorState } from '../../../src/components/StateViews';
import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';

/** Payment status detail (rent_payment_status_screen parity) + owner-invite entry. */
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

  const status = rentHistoryStatusMeta(entry.status);
  // Mock-only field: payout held means the owner hasn't linked a bank account.
  const payoutHeld = entry.payout_status === 'held' || entry.payout_status === 'queued';

  return (
    <Screen edges={[]}>
      <PageHeader title="Payment" />
      <View style={styles.body}>
        <View style={styles.hero}>
          <SuccessArt width={96} height={96} />
          <Text style={styles.heroAmount}>{formatRinggit(entry.amount)}</Text>
          <StatusTag label={status.label} status={status.tag} />
        </View>

        <Card style={styles.card}>
          <InfoRow label="Rental period" value={entry.rental_period} />
          {entry.payment_no ? <InfoRow label="Payment no." value={entry.payment_no} /> : null}
          {entry.payment_method ? (
            <InfoRow label="Method" value={entry.payment_method.toUpperCase()} />
          ) : null}
          <InfoRow label="Paid" value={entry.user_paid_at ?? entry.paid_at ?? '-'} />
          <InfoRow label="Timing" value={payStatusLabel(entry.pay_status)} />
          {entry.property_address ? (
            <InfoRow label="Property" value={entry.property_address} />
          ) : null}
          {entry.landlord_account_name ? (
            <InfoRow label="Owner" value={entry.landlord_account_name} />
          ) : null}
        </Card>

        {payoutHeld ? (
          <Card style={styles.card}>
            <Text style={styles.inviteTitle}>Owner payout pending</Text>
            <Text style={styles.inviteHint}>
              Invite your owner to NEAST so they can receive this payout.
            </Text>
            <Button
              title="Invite Owner"
              variant="outline"
              onPress={() => router.push('/pay-rent/invite-owner')}
            />
          </Card>
        ) : null}
      </View>
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
    flex: 1,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  hero: {
    alignItems: 'center',
    gap: spacing.sm,
    paddingVertical: spacing.lg,
  },
  heroArt: {
    width: 96,
    height: 96,
  },
  heroAmount: {
    ...textStyles.heading1,
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
  inviteTitle: {
    ...textStyles.heading3,
  },
  inviteHint: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
});
