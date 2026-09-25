import { StyleSheet, Text, View } from 'react-native';

import { formatThousands, type PointsLogItem } from '@neast/types';
import { coreColors, RefreshList, spacing, textStyles } from '@neast/ui-mobile';

import { getPointsLogs } from '../../src/lib/endpoints';
import { usePaginatedList } from '../../src/hooks/use-paginated';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';

/** Points history (points_history_screen parity): paginated earn/spend log. */
export default function PointsHistoryRoute() {
  const list = usePaginatedList(['points-logs'], (page, limit) => getPointsLogs(page, limit), 15);

  return (
    <Screen edges={[]}>
      <PageHeader title="Points History" />
      <RefreshList
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No points activity"
        emptyMessage="Earn points by paying rent and shopping with merchants."
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => <PointsLogRow item={item} />}
      />
    </Screen>
  );
}

function PointsLogRow({ item }: { item: PointsLogItem }) {
  const earned = item.points >= 0;
  return (
    <View style={styles.row}>
      <View style={styles.rowText}>
        <Text style={styles.rowTitle}>{item.title}</Text>
        {item.subtitle ? <Text style={styles.rowSubtitle}>{item.subtitle}</Text> : null}
        <Text style={styles.rowDate}>{item.created_at}</Text>
      </View>
      <Text style={[styles.rowPoints, earned ? styles.pointsEarned : styles.pointsSpent]}>
        {earned ? '+' : ''}
        {formatThousands(item.points)}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: coreColors.white,
    borderRadius: 12,
    padding: spacing.md,
    gap: spacing.md,
  },
  rowText: {
    flex: 1,
    gap: 2,
  },
  rowTitle: {
    ...textStyles.body,
    fontWeight: '500',
  },
  rowSubtitle: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  rowDate: {
    ...textStyles.caption,
  },
  rowPoints: {
    ...textStyles.body,
    fontWeight: '700',
  },
  pointsEarned: {
    color: coreColors.darkGreen,
  },
  pointsSpent: {
    color: coreColors.error,
  },
});
