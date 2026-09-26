import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';

import { formatRinggit, formatSimpleDate, type WalletTopupItem } from '@neast/types';
import {
  Card,
  coreColors,
  formatMonthLabel,
  MonthPicker,
  RefreshList,
  spacing,
  StatusTag,
  textStyles,
  type MonthValue,
  userHomeColors,
  PageHeader,
} from '@neast/ui-mobile';

import { getWalletTopups } from '@/lib/endpoints';
import { topupStatusMeta } from '@/lib/format';
import { usePaginatedList } from '@/hooks/use-paginated';
import { Screen } from '@/components/Screen';

/** Top-up records, optionally filtered to one month. */
export default function WalletHistoryRoute() {
  const [month, setMonth] = useState<MonthValue | null>(null);
  const [monthPickerVisible, setMonthPickerVisible] = useState(false);

  const topups = usePaginatedList(
    ['wallet-topups', month?.year ?? null, month?.month ?? null],
    (page, limit) => getWalletTopups({ page, limit, year: month?.year, month: month?.month }),
    10,
  );

  return (
    <Screen edges={[]}>
      <PageHeader title="Top-up history" />
      <RefreshList<WalletTopupItem>
        data={topups.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={topups.refreshing}
        onRefresh={topups.refresh}
        onLoadMore={topups.loadMore}
        hasMore={topups.hasMore}
        loadingMore={topups.loadingMore}
        contentContainerStyle={styles.listContent}
        ListHeaderComponent={
          <View style={styles.recordsHeader}>
            <Text style={styles.sectionTitle}>Records</Text>
            <Pressable
              onPress={() => setMonthPickerVisible(true)}
              accessibilityRole="button"
              style={styles.monthButton}
            >
              <Text style={styles.monthButtonText}>
                {month ? formatMonthLabel(month) : 'All months'}
              </Text>
            </Pressable>
          </View>
        }
        ListEmptyComponent={
          <Text style={styles.emptyText}>No top-ups{month ? ' this month' : ''} yet.</Text>
        }
        renderItem={({ item }) => <TopupRow item={item} />}
      />

      <MonthPicker
        visible={monthPickerVisible}
        onClose={() => setMonthPickerVisible(false)}
        onSelect={setMonth}
        selected={month ?? undefined}
      />
    </Screen>
  );
}

function TopupRow({ item }: { item: WalletTopupItem }) {
  const meta = topupStatusMeta(item.status);
  return (
    <Card style={styles.recordRow}>
      <View style={styles.recordText}>
        <Text style={styles.recordAmount}>{formatRinggit(item.amount)}</Text>
        <Text style={styles.recordMeta}>
          {item.payment_method.toUpperCase()}
          {item.channel ? ` · ${item.channel}` : ''} · {formatSimpleDate(item.created_at)}
        </Text>
      </View>
      <StatusTag status={meta.tag} label={meta.label} />
    </Card>
  );
}

const styles = StyleSheet.create({
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  recordsHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: spacing.sm,
  },
  sectionTitle: {
    ...textStyles.heading3,
    color: userHomeColors.textPrimary,
  },
  monthButton: {
    paddingVertical: spacing.xs,
    paddingHorizontal: spacing.sm,
  },
  monthButtonText: {
    ...textStyles.bodySmall,
    color: userHomeColors.navy,
    fontWeight: '600',
  },
  emptyText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    paddingVertical: spacing.lg,
  },
  recordRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  recordText: {
    flex: 1,
    gap: 2,
  },
  recordAmount: {
    ...textStyles.body,
    fontWeight: '600',
    color: userHomeColors.textPrimary,
  },
  recordMeta: {
    ...textStyles.caption,
  },
});
