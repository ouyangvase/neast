import { useState } from 'react';
import { Image, Pressable, StyleSheet, Text, View } from 'react-native';

import { formatRinggit, type LandlordRecordItem, type LandlordRecordListResponse } from '@neast/types';
import {
  coreColors,
  formatMonthLabel,
  GradientHeader,
  MonthPicker,
  RefreshList,
  spacing,
  textStyles,
  useUiTheme,
  type MonthValue,
} from '@neast/ui-mobile';

import { getRecordList } from '../../lib/endpoints';
import { usePaginatedList } from '../../hooks/use-paginated';
import { ListSkeleton } from '../../components/StateViews';

const now = new Date();

/** Records tab (records_screen parity): month picker + paginated settled payments. */
export function RecordsTab() {
  const theme = useUiTheme();
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
      <GradientHeader colors={theme.gradients.header} lightContent={false}>
        <View style={styles.headerRow}>
          <Text style={styles.title}>Records</Text>
          <Pressable
            onPress={() => setPickerVisible(true)}
            accessibilityRole="button"
            style={styles.monthButton}
          >
            <Text style={styles.monthButtonText}>{formatMonthLabel(month)}</Text>
          </Pressable>
        </View>
        <Text style={styles.totalLabel}>Collected in {formatMonthLabel(month)}</Text>
        <Text style={styles.totalValue}>{formatRinggit(list.firstPage?.amount_sum ?? 0)}</Text>
      </GradientHeader>

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
          renderItem={({ item }) => <RecordRow item={item} />}
        />
      )}

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
    backgroundColor: coreColors.white,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  title: {
    ...textStyles.heading1,
    color: coreColors.brandBlue,
  },
  monthButton: {
    borderWidth: 1,
    borderColor: coreColors.brandBlue,
    borderRadius: 999,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    backgroundColor: coreColors.white,
  },
  monthButtonText: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
  totalLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    marginTop: spacing.lg,
  },
  totalValue: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
    marginTop: spacing.xs,
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
    backgroundColor: coreColors.tintBlue,
    borderRadius: 12,
    padding: spacing.md,
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
  },
  avatarFallback: {
    backgroundColor: coreColors.brandBlue,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    ...textStyles.bodySmall,
    fontWeight: '700',
    color: coreColors.white,
  },
  rowBody: {
    flex: 1,
  },
  rowName: {
    ...textStyles.bodySmall,
    fontWeight: '600',
  },
  rowDate: {
    ...textStyles.caption,
    marginTop: 2,
  },
  rowAmount: {
    ...textStyles.body,
    fontWeight: '700',
    color: coreColors.darkGreen,
  },
});
