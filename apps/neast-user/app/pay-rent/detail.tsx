import { useMemo } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';

import { MONTH_INDEX, MONTH_NAMES_SHORT } from '@neast/constant';
import { formatRinggit, RENT_HISTORY_STATUS, RENT_STATUS, type RentPayStatus } from '@neast/types';
import { Chevron, spacing, userHomeColors } from '@neast/ui-mobile';

import HouseIcon from '@assets/images/pay_rent/house.svg';

import { getRentHistory, getRentList } from '@/lib/endpoints';
import { dueStatusLabel, payStatusLabel } from '@/lib/format';
import { isPaidHistory, type RentHistoryEntry } from '@/lib/types';
import { useSelectionStore } from '@/stores/selection';
import { ErrorState } from '@/components/StateViews';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';
import { TenancyCard } from '@/features/pay-rent/components';

type MonthTone = RentPayStatus | 'empty';

/** `October 2026` → 10. */
function monthFromPeriod(rentalPeriod: string): number | null {
  const month = MONTH_INDEX[(rentalPeriod.split(' ')[0] ?? '').toLowerCase()];
  return month || null;
}

/** Lease months (`first_pay_month` + `lease_months`) that fall in `year`. */
function leaseMonthsInYear(firstPayMonth: string, leaseMonths: number, year: number): number[] {
  const [startYear, startMonth] = firstPayMonth.split('-').map(Number);
  const months: number[] = [];
  for (let i = 0; i < leaseMonths; i += 1) {
    const index = startMonth - 1 + i;
    const y = startYear + Math.floor(index / 12);
    if (y === year) months.push((index % 12) + 1);
  }
  return months;
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
  const rents = useQuery({
    queryKey: ['rent-list'],
    queryFn: getRentList,
    enabled: !!rent,
  });
  const listed = rents.data?.items.find((item) => item.id === rent?.id) ?? rent;

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

  const yearFullyPaid = useMemo(() => {
    const current = listed ?? rent;
    if (!current) return false;
    const months = leaseMonthsInYear(current.first_pay_month, current.lease_months, year);
    return (
      months.length > 0 &&
      months.every((month) =>
        yearItems.some(
          (entry) => monthFromPeriod(entry.rental_period) === month && isPaidHistory(entry),
        ),
      )
    );
  }, [listed, rent, year, yearItems]);

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

  const current = listed ?? rent;
  const canPay = !!listed && listed.can_pay && listed.status === RENT_STATUS.approved;
  const canEdit =
    current.status === RENT_STATUS.pending || current.status === RENT_STATUS.rejected;
  const showAction = canEdit || canPay;

  return (
    <Screen edges={[]}>
      <PageHeader title="Tenancy" />
      <ScrollView
        contentContainerStyle={[
          styles.scroll,
          { paddingBottom: insets.bottom + (showAction ? 78 : 12) },
        ]}
      >
        <TenancyCard rent={current} summary />

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
            <InfoLine title="Rental Amount" value={formatRinggit(current.amount)} />
            {yearFullyPaid ? (
              <InfoLine title={`Fully paid of year of ${year}`} value="" />
            ) : (
              <InfoLine title={dueStatusLabel(current.due_status)} value={current.date_label} />
            )}
          </View>
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
          {recent.length === 0 ? (
            <Text style={styles.recentEmpty}>No recent payments yet.</Text>
          ) : (
            recent.map((entry) => <RecentRow key={entry.id} entry={entry} />)
          )}
        </View>
      </ScrollView>
      {showAction ? (
        <Pressable
          accessibilityRole="button"
          onPress={() => {
            setRent(current);
            if (canEdit) {
              router.push({
                pathname: current.property_id
                  ? '/pay-rent/create/connect'
                  : '/pay-rent/create/manual',
                params: { rentId: String(current.id) },
              });
              return;
            }
            router.push('/pay-rent/payment');
          }}
          style={({ pressed }) => [
            styles.ownerButton,
            { bottom: insets.bottom + 16 },
            pressed && styles.pressed,
          ]}
        >
          <Text style={styles.ownerButtonText}>{canEdit ? 'Edit details' : 'Pay Now'}</Text>
        </Pressable>
      ) : null}
    </Screen>
  );
}

function RecentRow({ entry }: { entry: RentHistoryEntry }) {
  return (
    <View style={styles.recentRow}>
      <Text style={styles.recentPeriod} numberOfLines={1}>
        {entry.rental_period}
      </Text>
      <Text style={styles.recentStatus}>{payStatusLabel(entry.pay_status)}</Text>
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
  recentEmpty: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
  },
  recentPeriod: {
    flex: 1,
    color: userHomeColors.textSecondary,
    fontSize: 11,
    lineHeight: 15,
    fontWeight: '600',
  },
  recentStatus: {
    width: 72,
    color: userHomeColors.textPrimary,
    fontSize: 11,
    lineHeight: 15,
    fontWeight: '700',
    textAlign: 'center',
  },
  recentAmount: {
    width: 108,
    color: userHomeColors.textPrimary,
    fontSize: 11,
    lineHeight: 15,
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
