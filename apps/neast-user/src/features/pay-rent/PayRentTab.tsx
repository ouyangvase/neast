import { RefreshControl, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn } from '@neast/types';
import {
  coreColors,
  GuestLoginPlaceholder,
  SectionHeader,
  spacing,
  textStyles,
} from '@neast/ui-mobile';

import unloginImage from '../../../assets/images/pay_rent/unlogin.png';

import { getRentHistory, getRentList } from '../../lib/endpoints';
import { useSelectionStore } from '../../stores/selection';
import { ListSkeleton } from '../../components/StateViews';
import { AddTenancyTile, HistoryRow, TenancyCard } from './components';

/** Pay Rent tab (pay_rent_screen parity): tenancies + recent history (≤5). */
export function PayRentTab() {
  const isLoggedIn = useIsLoggedIn();
  const setHistory = useSelectionStore((state) => state.setHistory);

  const rents = useQuery({
    queryKey: ['rent-list'],
    queryFn: getRentList,
    enabled: isLoggedIn,
  });

  const recentHistory = useQuery({
    queryKey: ['rent-history-recent'],
    queryFn: () => getRentHistory({ page: 1, limit: 5 }),
    enabled: isLoggedIn,
  });

  if (!isLoggedIn) {
    return (
      <View style={styles.guestContainer}>
        <Text style={styles.title}>Pay Rent</Text>
        <GuestLoginPlaceholder
          image={unloginImage}
          title="Log in to pay rent"
          message="Connect your tenancy and pay rent in a few taps."
          onLoginPress={() => router.push('/login')}
        />
      </View>
    );
  }

  const refreshing = rents.isRefetching || recentHistory.isRefetching;
  const onRefresh = () => {
    void rents.refetch();
    void recentHistory.refetch();
  };

  const items = rents.data?.items ?? [];
  const history = recentHistory.data?.items ?? [];
  const multiplier = Number(rents.data?.rent_points_multiplier ?? 1);

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
        contentContainerStyle={styles.scrollContent}
      >
        <Text style={styles.title}>Pay Rent</Text>
        {multiplier > 1 ? (
          <Text style={styles.multiplier}>Earn {multiplier}x points on every rent payment</Text>
        ) : null}

        {rents.isLoading ? (
          <ListSkeleton rows={2} />
        ) : (
          <>
            {items.map((rent) => (
              <TenancyCard key={rent.id} rent={rent} />
            ))}
            <AddTenancyTile />
          </>
        )}

        <View style={styles.historySection}>
          <SectionHeader
            title="Recent Payments"
            actionLabel="View all"
            onActionPress={() => router.push('/pay-rent/history')}
          />
          {recentHistory.isLoading ? (
            <ListSkeleton rows={2} />
          ) : history.length === 0 ? (
            <Text style={styles.emptyHistory}>No payments yet</Text>
          ) : (
            history.map((entry) => (
              <HistoryRow
                key={entry.id}
                entry={entry}
                onPress={() => {
                  setHistory(entry);
                  router.push('/pay-rent/history/detail');
                }}
              />
            ))
          )}
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  guestContainer: {
    flex: 1,
    backgroundColor: coreColors.white,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  scrollContent: {
    paddingBottom: spacing.xl,
  },
  title: {
    ...textStyles.heading1,
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.lg,
    paddingBottom: spacing.md,
  },
  multiplier: {
    ...textStyles.bodySmall,
    color: coreColors.darkGreen,
    paddingHorizontal: spacing.lg,
    marginBottom: spacing.sm,
  },
  historySection: {
    marginTop: spacing.md,
  },
  emptyHistory: {
    ...textStyles.bodySmall,
    color: coreColors.textHint,
    textAlign: 'center',
    paddingVertical: spacing.lg,
  },
});
