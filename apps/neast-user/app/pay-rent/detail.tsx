import { useMemo } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';

import { MONTH_INDEX, MONTH_NAMES_SHORT } from '@neast/constant';
import { formatRinggit, RENT_HISTORY_STATUS, RENT_STATUS, type RentPayStatus } from '@neast/types';
import { Chevron, spacing, userHomeColors } from '@neast/ui-mobile';

import HouseIcon from '../../assets/images/pay_rent/house.svg';

import { getRentHistory } from '../../src/lib/endpoints';
import { isPaidHistory, type RentHistoryEntry } from '../../src/lib/types';
import { useSelectionStore } from '../../src/stores/selection';
import { ErrorState } from '../../src/components/StateViews';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';
import { TenancyCard } from '../../src/features/pay-rent/components';

type MonthTone = RentPayStatus | 'empty';

/** `October 2026` → 10. */
function monthFromPeriod(rentalPeriod: string): number | null {
  const month = MONTH_INDEX[(rentalPeriod.split(' ')[0] ?? '').toLowerCase()];
  return month || null;
}

function monthTone(entry: RentHistoryEntry): MonthTone {
  if (entry.status === RENT_HISTORY_STATUS.cancelled) return 'empty';
  return entry.pay_status;
}

function toneColor(tone: MonthTone): string {
  switch (tone) {
    case 'on_time':
      return userHomeColors.navy;
    case 'late':
      return userHomeColors.royalBlue;
    case 'upcoming':
      return userHomeColors.upcomingBlue;
    default:
      return userHomeColors.emptyGrey;
  }
}

/** Tenancy detail: summary card, next payment, this year's rent status, and recent payments. */
export default function PayRentDetailRoute() {
  const insets = useSafeAreaInsets();
  const rent = useSelectionStore((state) => state.rent);
  const setRent = useSelectionStore((state) => state.setRent);
  const year = new Date().getFullYear();

  const history = useQuery({
    queryKey: ['rent-detail-history', rent?.id],
    queryFn: () => getRentHistory({ rent_id: rent!.id, page: 1, limit: 100 }),
    enabled: !!rent,
  });

  const yearItems = useMemo(
    () => (history.data?.items ?? []).filter((entry) => entry.rental_period.endsWith(` ${year}`)),
    [history.data, year],
  );

  const months = useMemo<MonthTone[]>(() => {
    const tones: MonthTone[] = Array.from({ length: 12 }, () => 'empty');
    for (const entry of yearItems) {
      const month = monthFromPeriod(entry.rental_period);
      if (!month) continue;
      const tone = monthTone(entry);
      if (tone === 'empty' && tones[month - 1] !== 'empty') continue;
      tones[month - 1] = tone;
    }
    return tones;
  }, [yearItems]);

  const recent = useMemo(
    () =>
      (history.data?.items ?? [])
        .filter(isPaidHistory)
        .sort((a, b) => b.last_paid_date.localeCompare(a.last_paid_date))
        .slice(0, 4),
    [history.data],
  );

  if (!rent) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Tenancy" />
        <ErrorState message="Tenancy unavailable." onRetry={() => router.back()} />
      </Screen>
    );
  }

  const canPay = rent.can_pay && rent.status === RENT_STATUS.approved;

  return (
    <Screen edges={[]}>
      <PageHeader title="Tenancy" />
      <ScrollView contentContainerStyle={[styles.scroll, { paddingBottom: insets.bottom + 78 }]}>
        <TenancyCard rent={rent} summary />

        <View style={[styles.card, styles.payCard]}>
          <Text style={styles.label}>{year}</Text>
          <View style={styles.grid}>
            {months.map((tone, index) => (
              <View key={MONTH_NAMES_SHORT[index]} style={styles.month}>
                <HouseIcon width={22} height={22} color={toneColor(tone)} />
                <Text style={styles.monthLabel}>{MONTH_NAMES_SHORT[index]}</Text>
              </View>
            ))}
          </View>
          <View style={styles.legend}>
            <Legend tone="on_time" label="On time" />
            <Legend tone="late" label="Late" />
            <Legend tone="upcoming" label="Upcoming" />
            <Legend tone="empty" label="No record" />
          </View>
          <View style={styles.infoLines}>
            <InfoLine title="Rental Amount" value={formatRinggit(rent.amount)} />
            <InfoLine
              title={rent.due_text || 'Due'}
              value={rent.date_label || 'Payment schedule pending'}
            />
          </View>
          {canPay ? (
            <Pressable
              accessibilityRole="button"
              onPress={() => {
                setRent(rent);
                router.push('/pay-rent/payment');
              }}
              style={({ pressed }) => [styles.payButton, pressed && styles.pressed]}
            >
              <Text style={styles.payText}>Pay Now</Text>
            </Pressable>
          ) : null}
        </View>

        <View style={[styles.card, styles.recentCard]}>
          <View style={styles.cardHeader}>
            <Text style={styles.recentTitle}>Recent payments</Text>
            <Pressable
              accessibilityRole="button"
              onPress={() => router.push('/pay-rent/recent')}
              style={({ pressed }) => [styles.viewAllButton, pressed && styles.pressed]}
            >
              <Text style={styles.viewAll}>View all</Text>
              <Chevron direction="right" color={userHomeColors.navy} size={8} />
            </Pressable>
          </View>
          {recent.map((entry) => (
            <RecentRow key={entry.id} entry={entry} />
          ))}
        </View>
      </ScrollView>
      {rent.owner_linked ? (
        <View
          style={[styles.ownerButton, styles.ownerButtonLinked, { bottom: insets.bottom + 16 }]}
        >
          <Text style={styles.ownerButtonText}>Connected with owner</Text>
        </View>
      ) : (
        <Pressable
          accessibilityRole="button"
          onPress={() => router.push('/pay-rent/invite-owner')}
          style={({ pressed }) => [
            styles.ownerButton,
            { bottom: insets.bottom + 16 },
            pressed && styles.pressed,
          ]}
        >
          <Text style={styles.ownerButtonText}>Connect with owner</Text>
        </Pressable>
      )}
    </Screen>
  );
}

function RecentRow({ entry }: { entry: RentHistoryEntry }) {
  return (
    <View style={styles.recentRow}>
      <Text style={styles.recentPeriod} numberOfLines={1}>
        {entry.rental_period}
      </Text>
      <Text style={styles.recentStatus}>{entry.pay_status === 'on_time' ? 'On time' : 'Due'}</Text>
      <Text style={styles.recentAmount}>{formatRinggit(entry.amount)}</Text>
    </View>
  );
}

function InfoLine({ title, value }: { title: string; value: string }) {
  return (
    <View style={styles.infoLine}>
      <Text style={styles.infoTitle}>{title}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

function Legend({ tone, label }: { tone: MonthTone; label: string }) {
  return (
    <View style={styles.legendItem}>
      <View style={[styles.legendDot, { backgroundColor: toneColor(tone) }]} />
      <Text style={styles.legendText}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: {
    padding: 12,
    gap: 6,
  },
  card: {
    backgroundColor: userHomeColors.surface,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: userHomeColors.border,
    padding: 12,
    gap: spacing.xs,
  },
  payCard: {
    gap: spacing.lg,
  },
  infoLines: {
    gap: spacing.xs,
  },
  infoLine: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  infoTitle: {
    flex: 1,
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '600',
  },
  infoValue: {
    flexShrink: 1,
    color: userHomeColors.textPrimary,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '700',
    textAlign: 'right',
  },
  recentCard: {
    padding: 14,
    gap: spacing.sm,
  },
  recentTitle: {
    flex: 1,
    color: userHomeColors.textPrimary,
    fontSize: 17,
    lineHeight: 22,
    fontWeight: '700',
  },
  recentRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  recentPeriod: {
    flex: 1,
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
  },
  recentStatus: {
    width: 72,
    color: userHomeColors.textPrimary,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '700',
    textAlign: 'center',
  },
  recentAmount: {
    width: 108,
    color: userHomeColors.textPrimary,
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '700',
    textAlign: 'right',
  },
  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
  },
  viewAllButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  viewAll: {
    color: userHomeColors.navy,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '700',
  },
  ownerButton: {
    position: 'absolute',
    left: 14,
    right: 14,
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 16,
  },
  ownerButtonLinked: {
    backgroundColor: userHomeColors.emptyGrey,
  },
  ownerButtonText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  label: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '600',
  },
  payButton: {
    minHeight: 36,
    borderRadius: 8,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
  },
  payText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  month: {
    width: '16.666%',
    alignItems: 'center',
    gap: 2,
    paddingVertical: 4,
  },
  monthLabel: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
  },
  legend: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'center',
    alignItems: 'center',
    gap: 8,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  legendDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  legendText: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
  },
  pressed: {
    opacity: 0.7,
  },
});
