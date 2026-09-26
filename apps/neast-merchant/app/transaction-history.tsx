import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import {
  formatRinggit,
  formatSimpleDate,
  formatThousands,
  type MerchantPointsTransactionItem,
  type MerchantRedeemedTransactionItem,
} from '@neast/types';
import { BrandHeader, coreColors, RefreshList, spacing, textStyles } from '@neast/ui-mobile';

import { getPointsTransactions, getRedeemedTransactions } from '@/lib/endpoints';
import { yearChips } from '@/lib/format';
import { usePaginatedList } from '@/hooks/use-paginated';
import { Screen } from '@/components/Screen';

type HistoryTab = 'points' | 'redeemed';

/**
 * Transaction history (transaction_history_screen parity): Points / Redeemed
 * tabs with a year filter, each paginated.
 */
export default function TransactionHistoryRoute() {
  const [tab, setTab] = useState<HistoryTab>('points');
  const [year, setYear] = useState(() => new Date().getFullYear());

  return (
    <Screen>
      <BrandHeader title="Transaction History" onBack={() => router.back()} />
      <View style={styles.tabs}>
        <TabChip label="Points" active={tab === 'points'} onPress={() => setTab('points')} />
        <TabChip label="Redeemed" active={tab === 'redeemed'} onPress={() => setTab('redeemed')} />
      </View>
      <View style={styles.yearFilter}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <View style={styles.yearRow}>
            {yearChips().map((option) => (
              <YearChip
                key={option}
                year={option}
                active={year === option}
                onPress={() => setYear(option)}
              />
            ))}
          </View>
        </ScrollView>
      </View>
      {tab === 'points' ? <PointsList year={year} /> : <RedeemedList year={year} />}
    </Screen>
  );
}

function PointsList({ year }: { year: number }) {
  const list = usePaginatedList(['transactions', 'points', year], (page, limit) =>
    getPointsTransactions(year, page, limit),
  );
  return (
    <RefreshList
      data={list.items}
      keyExtractor={(item) => String(item.id)}
      refreshing={list.refreshing}
      onRefresh={list.refresh}
      onLoadMore={list.loadMore}
      hasMore={list.hasMore}
      loadingMore={list.loadingMore}
      emptyTitle="No points transactions"
      emptyMessage="Points you give will appear here."
      contentContainerStyle={styles.listContent}
      renderItem={({ item }) => <PointsRow item={item} />}
    />
  );
}

function RedeemedList({ year }: { year: number }) {
  const list = usePaginatedList(['transactions', 'redeemed', year], (page, limit) =>
    getRedeemedTransactions(year, page, limit),
  );
  return (
    <RefreshList
      data={list.items}
      keyExtractor={(item) => String(item.id)}
      refreshing={list.refreshing}
      onRefresh={list.refresh}
      onLoadMore={list.loadMore}
      hasMore={list.hasMore}
      loadingMore={list.loadingMore}
      emptyTitle="No redeemed coupons"
      emptyMessage="Coupons you redeem will appear here."
      contentContainerStyle={styles.listContent}
      renderItem={({ item }) => <RedeemedRow item={item} />}
    />
  );
}

function PointsRow({ item }: { item: MerchantPointsTransactionItem }) {
  return (
    <View style={styles.row}>
      <View style={styles.rowTexts}>
        <Text style={styles.rowTitle}>+{formatThousands(item.points)} pts</Text>
        <Text style={styles.rowMeta}>{formatSimpleDate(item.created_at)}</Text>
      </View>
      <Text style={styles.rowValue}>{formatRinggit(item.amount)}</Text>
    </View>
  );
}

function RedeemedRow({ item }: { item: MerchantRedeemedTransactionItem }) {
  return (
    <View style={styles.row}>
      <View style={styles.rowTexts}>
        <Text style={styles.rowTitle}>{item.name}</Text>
        <Text style={styles.rowMeta}>{formatSimpleDate(item.redeemed_at)}</Text>
      </View>
    </View>
  );
}

function TabChip({
  label,
  active,
  onPress,
}: {
  label: string;
  active: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      style={[styles.tabChip, active && styles.tabChipActive]}
      onPress={onPress}
      accessibilityRole="button"
    >
      <Text style={[styles.tabChipText, active && styles.tabChipTextActive]}>{label}</Text>
    </Pressable>
  );
}

function YearChip({
  year,
  active,
  onPress,
}: {
  year: number;
  active: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      style={[styles.yearChip, active && styles.yearChipActive]}
      onPress={onPress}
      accessibilityRole="button"
    >
      <Text style={[styles.yearChipText, active && styles.yearChipTextActive]}>{year}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  tabs: {
    flexDirection: 'row',
    gap: spacing.sm,
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.sm,
  },
  tabChip: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: spacing.sm,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: coreColors.borderLight,
  },
  tabChipActive: {
    borderColor: coreColors.brandBlueLight,
    backgroundColor: coreColors.brandBlueLight,
  },
  tabChipText: {
    ...textStyles.body,
    color: coreColors.blackText,
  },
  tabChipTextActive: {
    color: coreColors.white,
    fontWeight: '600',
  },
  yearFilter: {
    paddingBottom: spacing.sm,
  },
  yearRow: {
    flexDirection: 'row',
    gap: spacing.sm,
    paddingHorizontal: spacing.lg,
  },
  yearChip: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: 999,
    borderWidth: 1,
    borderColor: coreColors.borderLight,
  },
  yearChipActive: {
    borderColor: coreColors.brandBlueLight,
    backgroundColor: coreColors.tintBlue,
  },
  yearChipText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  yearChipTextActive: {
    color: coreColors.brandBlueLight,
    fontWeight: '600',
  },
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: coreColors.tintBlue,
    borderRadius: 12,
    padding: spacing.md,
  },
  rowTexts: {
    flex: 1,
  },
  rowTitle: {
    ...textStyles.body,
    fontWeight: '600',
  },
  rowMeta: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  rowValue: {
    ...textStyles.body,
    color: coreColors.brandBlue,
    fontWeight: '700',
  },
});
