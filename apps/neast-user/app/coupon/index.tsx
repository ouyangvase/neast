import { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import type { CouponListItem } from '@neast/types';
import { BrandHeader, coreColors, radii, RefreshList, spacing, textStyles } from '@neast/ui-mobile';

import { getCouponCategories, getCouponList } from '../../src/lib/endpoints';
import { usePaginatedList } from '../../src/hooks/use-paginated';
import { useSelectionStore } from '../../src/stores/selection';
import { CouponCard } from '../../src/features/coupon/components';
import { Screen } from '../../src/components/Screen';
import { useQuery } from '@tanstack/react-query';

/** Coupon catalog (coupon_screen parity): category chips + paginated list. */
export default function CouponRoute() {
  const [categoryId, setCategoryId] = useState<number | null>(null);

  const categories = useQuery({
    queryKey: ['coupon-categories'],
    queryFn: getCouponCategories,
    staleTime: 5 * 60 * 1000,
  });

  const list = usePaginatedList(
    ['coupon-list', categoryId],
    (page, limit) => getCouponList(page, limit, categoryId ?? undefined),
    15,
  );

  return (
    <Screen>
      <BrandHeader title="Vouchers" onBack={() => router.back()} />
      <View style={styles.chipsWrap}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <View style={styles.chipsRow}>
            <Chip label="All" active={categoryId === null} onPress={() => setCategoryId(null)} />
            {(categories.data?.items ?? []).map((category) => (
              <Chip
                key={category.id}
                label={category.name}
                active={categoryId === category.id}
                onPress={() => setCategoryId(category.id)}
              />
            ))}
          </View>
        </ScrollView>
      </View>
      <RefreshList<CouponListItem>
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No vouchers"
        emptyMessage="No vouchers in this category right now."
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <CouponCard
            coupon={item}
            onPress={() => {
              useSelectionStore.getState().setCoupon(item);
              router.push({ pathname: '/coupon/detail', params: { id: String(item.id) } });
            }}
          />
        )}
      />
    </Screen>
  );
}

function Chip({ label, active, onPress }: { label: string; active: boolean; onPress: () => void }) {
  return (
    <Pressable
      style={[styles.chip, active && styles.chipActive]}
      onPress={onPress}
      accessibilityRole="button"
    >
      <Text style={[styles.chipText, active && styles.chipTextActive]}>{label}</Text>
    </Pressable>
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
