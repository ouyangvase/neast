import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit, RENT_STATUS, type RentListItem } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  radii,
  spacing,
  StatusTag,
  textStyles,
  userAccentColors,
} from '@neast/ui-mobile';

import addIcon from '../../../assets/images/pay_rent/add-icon.png';

import { rentHistoryStatusMeta, rentStatusMeta } from '../../lib/format';
import type { RentHistoryEntry } from '../../lib/types';
import { useSelectionStore } from '../../stores/selection';

/** Tenancy card on the Pay Rent tab (tenancy_card parity). */
export function TenancyCard({ rent }: { rent: RentListItem }) {
  const setRent = useSelectionStore((state) => state.setRent);
  const status = rentStatusMeta(rent.status);
  const canPay = rent.can_pay && rent.status === RENT_STATUS.approved;

  const openDetail = () => {
    setRent(rent);
    router.push('/pay-rent/detail');
  };

  return (
    <Card onPress={openDetail} style={styles.card}>
      <View style={styles.titleRow}>
        <Text style={styles.property} numberOfLines={1}>
          {rent.property_name}
        </Text>
        <StatusTag label={status.label} status={status.tag} />
      </View>
      <Text style={styles.amount}>{formatRinggit(rent.amount)}</Text>
      <Text style={styles.due}>
        {rent.due_text}
        {rent.date_label ? ` · ${rent.date_label}` : ''}
      </Text>
      <View style={styles.metaRow}>
        {rent.earn_points > 0 ? (
          <View style={styles.pointsChip}>
            <Text style={styles.pointsChipText}>Earn {rent.earn_points} pts</Text>
          </View>
        ) : null}
        {rent.landlord_name ? (
          <Text style={styles.landlord} numberOfLines={1}>
            Owner: {rent.landlord_name}
          </Text>
        ) : null}
      </View>
      {canPay ? (
        <Button
          title="Pay Now"
          size="small"
          onPress={() => {
            setRent(rent);
            router.push('/pay-rent/payment');
          }}
          style={styles.payButton}
        />
      ) : null}
    </Card>
  );
}

/** "Add Tenancy" dashed tile. */
export function AddTenancyTile() {
  return (
    <Pressable
      style={styles.addTile}
      onPress={() => router.push('/pay-rent/create')}
      accessibilityRole="button"
    >
      <Image source={addIcon} style={styles.addIcon} resizeMode="contain" />
      <Text style={styles.addText}>Add Tenancy</Text>
    </Pressable>
  );
}

/** Rent history row (recent section + history list). */
export function HistoryRow({ entry, onPress }: { entry: RentHistoryEntry; onPress?: () => void }) {
  const status = rentHistoryStatusMeta(entry.status);
  return (
    <Card onPress={onPress} style={styles.historyCard}>
      <View style={styles.titleRow}>
        <Text style={styles.historyPeriod}>{entry.rental_period}</Text>
        <StatusTag label={status.label} status={status.tag} />
      </View>
      <Text style={styles.historyAmount}>{formatRinggit(entry.amount)}</Text>
      <Text style={styles.historyMeta} numberOfLines={1}>
        {entry.property_address}
        {entry.payment_no ? ` · ${entry.payment_no}` : ''}
      </Text>
    </Card>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.md,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.sm,
  },
  property: {
    ...textStyles.heading3,
    flex: 1,
  },
  amount: {
    ...textStyles.numeric,
    color: coreColors.brandBlue,
    marginTop: spacing.sm,
  },
  due: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: spacing.xs,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    marginTop: spacing.sm,
  },
  pointsChip: {
    backgroundColor: userAccentColors.tierBackground,
    borderRadius: radii.pill,
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
  },
  pointsChipText: {
    ...textStyles.caption,
    color: userAccentColors.pointsDeal,
    fontWeight: '600',
  },
  landlord: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    flex: 1,
  },
  payButton: {
    marginTop: spacing.md,
    alignSelf: 'flex-start',
  },
  addTile: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.md,
    borderWidth: 1,
    borderStyle: 'dashed',
    borderColor: coreColors.border,
    borderRadius: radii.card,
    paddingVertical: spacing.xl,
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.sm,
  },
  addIcon: {
    width: 32,
    height: 32,
  },
  addText: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
  historyCard: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.sm,
  },
  historyPeriod: {
    ...textStyles.body,
    fontWeight: '600',
  },
  historyAmount: {
    ...textStyles.body,
    color: coreColors.brandBlue,
    fontWeight: '700',
    marginTop: spacing.xs,
  },
  historyMeta: {
    ...textStyles.caption,
    marginTop: 2,
  },
});
