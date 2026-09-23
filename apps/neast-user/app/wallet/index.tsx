import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { formatRinggit, formatSimpleDate, type WalletTopupItem } from '@neast/types';
import {
  Button,
  Card,
  coreColors,
  GradientHeader,
  MonthPicker,
  type MonthValue,
  formatMonthLabel,
  RefreshList,
  spacing,
  StatusTag,
  TextField,
  textStyles,
  useUiTheme,
} from '@neast/ui-mobile';

import { getWalletBalance, getWalletTopups } from '../../src/lib/endpoints';
import { topupStatusMeta } from '../../src/lib/format';
import { usePaginatedList } from '../../src/hooks/use-paginated';
import { Screen } from '../../src/components/Screen';

const PRESET_AMOUNTS = [500, 1000, 1500, 2000];

/** Wallet (wallet_screen parity): balance, preset/custom top-up, monthly records. */
export default function WalletRoute() {
  const theme = useUiTheme();
  const [amount, setAmount] = useState('');
  const [month, setMonth] = useState<MonthValue | null>(null);
  const [monthPickerVisible, setMonthPickerVisible] = useState(false);

  const balance = useQuery({
    queryKey: ['wallet-balance'],
    queryFn: getWalletBalance,
  });

  const topups = usePaginatedList(
    ['wallet-topups', month?.year ?? null, month?.month ?? null],
    (page, limit) => getWalletTopups({ page, limit, year: month?.year, month: month?.month }),
    10,
  );

  const proceed = (value: string) => {
    const numeric = Number(value);
    if (!Number.isFinite(numeric) || numeric <= 0) {
      return;
    }
    router.push({
      pathname: '/wallet/payment',
      params: { amount: numeric.toFixed(2), amountLabel: formatRinggit(value) },
    });
  };

  return (
    <Screen edges={[]}>
      <GradientHeader colors={theme.gradients.header} title="Wallet" onBack={() => router.back()} />
      <RefreshList<WalletTopupItem>
        data={topups.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={topups.refreshing}
        onRefresh={() => {
          void balance.refetch();
          void topups.refresh();
        }}
        onLoadMore={topups.loadMore}
        hasMore={topups.hasMore}
        loadingMore={topups.loadingMore}
        contentContainerStyle={styles.listContent}
        ListHeaderComponent={
          <View style={styles.headerContent}>
            <Card style={styles.balanceCard}>
              <Text style={styles.balanceLabel}>Current balance</Text>
              <Text style={styles.balanceValue}>
                {formatRinggit(balance.data?.balance ?? '0.00')}
              </Text>
            </Card>

            <Card style={styles.topupCard}>
              <Text style={styles.sectionTitle}>Top up</Text>
              <View style={styles.presetRow}>
                {PRESET_AMOUNTS.map((preset) => (
                  <Pressable
                    key={preset}
                    style={[
                      styles.presetChip,
                      amount === String(preset) && styles.presetChipActive,
                    ]}
                    onPress={() => setAmount(String(preset))}
                    accessibilityRole="button"
                  >
                    <Text
                      style={[
                        styles.presetText,
                        amount === String(preset) && styles.presetTextActive,
                      ]}
                    >
                      RM{preset}
                    </Text>
                  </Pressable>
                ))}
              </View>
              <TextField
                label="Custom amount (RM)"
                value={amount}
                onChangeText={setAmount}
                keyboardType="decimal-pad"
                placeholder="0.00"
              />
              <Button
                title="Top Up"
                onPress={() => proceed(amount)}
                disabled={!Number(amount) || Number(amount) <= 0}
                style={styles.topupButton}
              />
            </Card>

            <View style={styles.recordsHeader}>
              <Text style={styles.sectionTitle}>Top-up records</Text>
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
  headerContent: {
    gap: spacing.lg,
    marginBottom: spacing.sm,
  },
  balanceCard: {
    alignItems: 'center',
    paddingVertical: spacing.xl,
  },
  balanceLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  balanceValue: {
    ...textStyles.heading1,
    fontSize: 34,
    marginTop: spacing.xs,
  },
  topupCard: {
    gap: spacing.md,
  },
  sectionTitle: {
    ...textStyles.heading3,
  },
  presetRow: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  presetChip: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: spacing.sm,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: coreColors.border,
    backgroundColor: coreColors.white,
  },
  presetChipActive: {
    borderColor: coreColors.brandBlue,
    backgroundColor: coreColors.tintBlue,
  },
  presetText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  presetTextActive: {
    color: coreColors.brandBlue,
    fontWeight: '600',
  },
  topupButton: {
    marginTop: spacing.xs,
  },
  recordsHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  monthButton: {
    paddingVertical: spacing.xs,
    paddingHorizontal: spacing.sm,
  },
  monthButtonText: {
    ...textStyles.bodySmall,
    color: coreColors.brandBlue,
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
  },
  recordMeta: {
    ...textStyles.caption,
  },
});
