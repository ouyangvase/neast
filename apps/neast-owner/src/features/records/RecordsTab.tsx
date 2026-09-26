import { useState } from 'react';
import { Image, ImageBackground, Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { formatRinggit, type LandlordRecordItem, type LandlordRecordListResponse } from '@neast/types';
import {
  formatMonthLabel,
  MonthPicker,
  RefreshList,
  spacing,
  textStyles,
  userHomeColors,
  type MonthValue,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { getRecordList } from '@/lib/endpoints';
import { usePaginatedList } from '@/hooks/use-paginated';
import { ListSkeleton } from '@/components/StateViews';

const now = new Date();

/** Records tab: month picker and paginated settled payments. */
export function RecordsTab() {
  const insets = useSafeAreaInsets();
  const [month, setMonth] = useState<MonthValue>({
    year: now.getFullYear(),
    month: now.getMonth() + 1,
  });
  const [pickerVisible, setPickerVisible] = useState(false);

  const list = usePaginatedList<LandlordRecordItem, LandlordRecordListResponse>(
    ['records', month.year, month.month],
    (page, limit) => getRecordList({ year: month.year, month: month.month, page, limit }),
  );

  return (
    <View style={styles.container}>
      <ImageBackground
        source={metallicBackground}
        resizeMode="cover"
        style={[styles.backdrop, { paddingTop: insets.top + 8 }]}
      >
        <View style={styles.headerRow}>
          <Text style={styles.title}>Records</Text>
          <Pressable
            onPress={() => setPickerVisible(true)}
            accessibilityRole="button"
            accessibilityLabel="Select month"
            style={styles.monthButton}
          >
            <Text style={styles.monthButtonText}>{formatMonthLabel(month)}</Text>
          </Pressable>
        </View>
        <Text style={styles.totalLabel}>Collected in {formatMonthLabel(month)}</Text>
        {list.firstPage ? (
          <Text style={styles.totalValue}>{formatRinggit(list.firstPage.amount_sum)}</Text>
        ) : null}
      </ImageBackground>

      <View style={styles.sheet}>
        {list.isLoading ? (
          <ListSkeleton rows={5} />
        ) : (
          <RefreshList
            data={list.items}
            keyExtractor={(item) => String(item.id)}
            refreshing={list.refreshing}
            onRefresh={list.refresh}
            onLoadMore={list.loadMore}
            hasMore={list.hasMore}
            loadingMore={list.loadingMore}
            emptyTitle="No records"
            emptyMessage="No settled payments for this month."
            contentContainerStyle={styles.listContent}
            style={styles.list}
            renderItem={({ item }) => <RecordRow item={item} />}
          />
        )}
      </View>

      <MonthPicker
        visible={pickerVisible}
        onClose={() => setPickerVisible(false)}
        onSelect={setMonth}
        selected={month}
      />
    </View>
  );
}

function RecordRow({ item }: { item: LandlordRecordItem }) {
  return (
    <View style={styles.row}>
      {item.avatar ? (
        <Image source={{ uri: item.avatar }} style={styles.avatar} />
      ) : (
        <View style={[styles.avatar, styles.avatarFallback]}>
          <Text style={styles.avatarText}>{item.initials}</Text>
        </View>
      )}
      <View style={styles.rowBody}>
        <Text style={styles.rowName} numberOfLines={1}>
          {item.user_name}
        </Text>
        <Text style={styles.rowDate}>{item.created_at}</Text>
      </View>
      <Text style={styles.rowAmount}>+RM{item.amount}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  backdrop: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
    paddingHorizontal: 20,
    paddingBottom: 48,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    letterSpacing: -0.4,
  },
  monthButton: {
    borderRadius: 999,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    backgroundColor: userHomeColors.surface,
  },
  monthButtonText: {
    ...textStyles.bodySmall,
    color: userHomeColors.navy,
    fontWeight: '600',
  },
  totalLabel: {
    ...textStyles.bodySmall,
    color: userHomeColors.textOnNavyAlt,
    marginTop: spacing.lg,
  },
  totalValue: {
    ...textStyles.displayLarge,
    color: userHomeColors.surface,
    marginTop: spacing.xs,
  },
  sheet: {
    flex: 1,
    marginTop: -20,
    backgroundColor: userHomeColors.background,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
    overflow: 'hidden',
  },
  list: {
    flex: 1,
  },
  listContent: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
    gap: spacing.sm,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    backgroundColor: userHomeColors.surface,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: userHomeColors.border,
    borderRadius: 12,
    padding: spacing.md,
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
  },
  avatarFallback: {
    backgroundColor: userHomeColors.lightBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: userHomeColors.navy,
  },
  rowBody: {
    flex: 1,
  },
  rowName: {
    ...textStyles.bodySmall,
    fontWeight: '600',
    color: userHomeColors.textPrimary,
  },
  rowDate: {
    ...textStyles.caption,
    color: userHomeColors.textSecondary,
    marginTop: 2,
  },
  rowAmount: {
    ...textStyles.body,
    fontWeight: '700',
    color: userHomeColors.navy,
  },
});
