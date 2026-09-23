import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { BrandHeader, coreColors, radii, RefreshList, spacing, textStyles } from '@neast/ui-mobile';

import { getRentHistory } from '../../../src/lib/endpoints';
import { yearChips } from '../../../src/lib/format';
import type { RentHistoryEntry } from '../../../src/lib/types';
import { usePaginatedList } from '../../../src/hooks/use-paginated';
import { useSelectionStore } from '../../../src/stores/selection';
import { HistoryRow } from '../../../src/features/pay-rent/components';
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
    <Screen>
      <BrandHeader title="Rent History" onBack={() => router.back()} />
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
    paddingVertical: spacing.sm,
  },
  chipsRow: {
    flexDirection: 'row',
    gap: spacing.sm,
    paddingHorizontal: spacing.lg,
  },
  chip: {
    backgroundColor: coreColors.white,
    borderRadius: radii.pill,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderWidth: 1,
    borderColor: coreColors.border,
  },
  chipActive: {
    backgroundColor: coreColors.brandBlue,
    borderColor: coreColors.brandBlue,
  },
  chipText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  chipTextActive: {
    color: coreColors.white,
    fontWeight: '600',
  },
  listContent: {
    paddingVertical: spacing.sm,
  },
});
