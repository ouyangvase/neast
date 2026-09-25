import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { RefreshList, userHomeColors } from '@neast/ui-mobile';

import { getRentHistory } from '../../../src/lib/endpoints';
import { yearChips } from '../../../src/lib/format';
import type { RentHistoryEntry } from '../../../src/lib/types';
import { usePaginatedList } from '../../../src/hooks/use-paginated';
import { useSelectionStore } from '../../../src/stores/selection';
import { HistoryRow } from '../../../src/features/pay-rent/components';
import { PageHeader } from '../../../src/components/PageHeader';
import { Screen } from '../../../src/components/Screen';

/** Full rent history (rent_history_screen parity): year filter chips. */
export default function RentHistoryRoute() {
  const [year, setYear] = useState<number>(new Date().getFullYear());

  const list = usePaginatedList(
    ['rent-history', year],
    (page, limit) => getRentHistory({ page, limit, year }),
    15,
  );

  return (
    <Screen edges={[]}>
      <PageHeader title="Recent payments" />
      <View style={styles.chipsWrap}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <View style={styles.chipsRow}>
            {yearChips().map((chipYear) => (
              <Pressable
                key={chipYear}
                style={[styles.chip, year === chipYear && styles.chipActive]}
                onPress={() => setYear(chipYear)}
                accessibilityRole="button"
              >
                <Text style={[styles.chipText, year === chipYear && styles.chipTextActive]}>
                  {chipYear}
                </Text>
              </Pressable>
            ))}
          </View>
        </ScrollView>
      </View>
      <RefreshList<RentHistoryEntry>
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No payments"
        emptyMessage={`No rent payments in ${year}.`}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <HistoryRow
            entry={item}
            onPress={() => {
              useSelectionStore.getState().setHistory(item);
              router.push('/pay-rent/history/detail');
            }}
          />
        )}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  chipsWrap: {
    paddingVertical: 8,
    backgroundColor: userHomeColors.background,
  },
  chipsRow: {
    flexDirection: 'row',
    gap: 8,
    paddingHorizontal: 14,
  },
  chip: {
    backgroundColor: userHomeColors.surface,
    borderRadius: 999,
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderWidth: 1,
    borderColor: userHomeColors.border,
  },
  chipActive: {
    backgroundColor: userHomeColors.royalBlue,
    borderColor: userHomeColors.royalBlue,
  },
  chipText: {
    color: userHomeColors.textSecondary,
    fontSize: 13,
    lineHeight: 18,
  },
  chipTextActive: {
    color: userHomeColors.surface,
    fontWeight: '600',
  },
  listContent: {
    paddingVertical: 8,
    backgroundColor: userHomeColors.background,
  },
});
