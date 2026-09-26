import { Image, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import {
  formatRinggit,
  formatThousands,
  useIsLoggedIn,
  type DailyClosingTransactionItem,
} from '@neast/types';
import {
  BrandHeader,
  Card,
  coreColors,
  RefreshList,
  spacing,
  textStyles,
} from '@neast/ui-mobile';

import stat1Icon from '@assets/images/daily_closing/stat1.png';
import stat2Icon from '@assets/images/daily_closing/stat2.png';
import stat3Icon from '@assets/images/daily_closing/stat3.png';

import { getDailyClosingSummary, getDailyClosingTransactions } from '@/lib/endpoints';
import { usePaginatedList } from '@/hooks/use-paginated';
import { Screen } from '@/components/Screen';

/**
 * Daily closing (daily_closing_screen parity): today's summary card +
 * paginated transactions. The Flutter "Export Report" button is a no-op stub
 * and is intentionally omitted (see PARITY.md).
 */
export default function DailyClosingRoute() {
  const isLoggedIn = useIsLoggedIn();
  const summary = useQuery({
    queryKey: ['daily-closing', 'summary'],
    queryFn: getDailyClosingSummary,
    enabled: isLoggedIn,
  });
  const list = usePaginatedList(['daily-closing', 'transactions'], (page, limit) =>
    getDailyClosingTransactions(page, limit),
  );

  return (
    <Screen>
      <BrandHeader title="Daily Closing" onBack={() => router.back()} />
      <RefreshList
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No transactions yet"
        emptyMessage="Today's given points will appear here."
        contentContainerStyle={styles.listContent}
        ListHeaderComponent={
          <Card style={styles.summaryCard}>
            <Text style={styles.summaryLabel}>Today's commission</Text>
            <Text style={styles.summaryValue}>
              {summary.data ? formatRinggit(summary.data.commission_rm) : '—'}
            </Text>
            <View style={styles.summaryStats}>
              <SummaryStat
                icon={stat1Icon}
                label="Points"
                value={summary.data ? formatThousands(summary.data.points) : '—'}
              />
              <SummaryStat
                icon={stat2Icon}
                label="Customers"
                value={summary.data ? String(summary.data.customers) : '—'}
              />
              <SummaryStat
                icon={stat3Icon}
                label="Redeemed"
                value={summary.data ? String(summary.data.redeemed) : '—'}
              />
            </View>
          </Card>
        }
        renderItem={({ item }) => <TransactionRow item={item} />}
      />
    </Screen>
  );
}

function SummaryStat({
  icon,
  label,
  value,
}: {
  icon: number;
  label: string;
  value: string;
}) {
  return (
    <View style={styles.summaryStat}>
      <Image source={icon} style={styles.summaryStatIcon} />
      <Text style={styles.summaryStatValue}>{value}</Text>
      <Text style={styles.summaryStatLabel}>{label}</Text>
    </View>
  );
}

function TransactionRow({ item }: { item: DailyClosingTransactionItem }) {
  return (
    <View style={styles.row}>
      <View style={styles.rowTexts}>
        <Text style={styles.rowTitle}>{item.user_name}</Text>
        <Text style={styles.rowTime}>{item.time}</Text>
      </View>
      <View style={styles.rowRight}>
        <Text style={styles.rowPoints}>+{formatThousands(item.points)} pts</Text>
        <Text style={styles.rowAmount}>{formatRinggit(item.amount)}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  summaryCard: {
    marginBottom: spacing.md,
    gap: spacing.sm,
  },
  summaryLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  summaryValue: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
  },
  summaryStats: {
    flexDirection: 'row',
    marginTop: spacing.sm,
  },
  summaryStat: {
    flex: 1,
    alignItems: 'center',
    gap: 2,
  },
  summaryStatIcon: {
    width: 28,
    height: 28,
    marginBottom: 2,
  },
  summaryStatValue: {
    ...textStyles.heading3,
  },
  summaryStatLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
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
  rowTime: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  rowRight: {
    alignItems: 'flex-end',
  },
  rowPoints: {
    ...textStyles.body,
    color: coreColors.darkGreen,
    fontWeight: '700',
  },
  rowAmount: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
});
