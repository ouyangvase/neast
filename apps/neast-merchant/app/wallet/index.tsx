import { useState } from 'react';
import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import {
  formatRinggit,
  formatSimpleDate,
  formatThousands,
  type MerchantTopupItem,
} from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  RefreshList,
  spacing,
  StatusTag,
  TextField,
  textStyles,
} from '@neast/ui-mobile';

import balanceIcon from '../../assets/images/wallet/balance-icon.png';

import { getWalletTopups } from '../../src/lib/endpoints';
import { topupStatusMeta } from '../../src/lib/format';
import { useMerchantInfo } from '../../src/hooks/use-merchant';
import { usePaginatedList } from '../../src/hooks/use-paginated';
import { Screen } from '../../src/components/Screen';

/** wallet_config.dart preset amounts. */
const PRESET_AMOUNTS = ['500', '1000', '1500', '2000'];

/**
 * Wallet (wallet_screen parity): balance card (from /merchant/info), preset +
 * custom top-up amounts, top-up record list.
 */
export default function WalletRoute() {
  const info = useMerchantInfo();
  const [amount, setAmount] = useState('500');
  const [custom, setCustom] = useState('');
  const list = usePaginatedList(['wallet-topups'], (page, limit) => getWalletTopups(page, limit));

  const effectiveAmount = custom.trim() !== '' ? custom.trim() : amount;
  const canContinue = Number(effectiveAmount) > 0;

  const continueToPayment = () => {
    if (!canContinue) {
      return;
    }
    router.push({ pathname: '/wallet/payment', params: { amount: effectiveAmount } });
  };

  return (
    <Screen>
      <BrandHeader title="Wallet Top Up" onBack={() => router.back()} />
      <RefreshList
        data={list.items}
        keyExtractor={(item) => String(item.id)}
        refreshing={list.refreshing}
        onRefresh={list.refresh}
        onLoadMore={list.loadMore}
        hasMore={list.hasMore}
        loadingMore={list.loadingMore}
        emptyTitle="No top-ups yet"
        emptyMessage="Your top-up records will appear here."
        contentContainerStyle={styles.listContent}
        ListHeaderComponent={
          <View style={styles.header}>
            <Card style={styles.balanceCard}>
              <Image source={balanceIcon} style={styles.balanceIcon} />
              <View>
                <Text style={styles.balanceLabel}>Wallet balance</Text>
                <Text style={styles.balanceValue}>
                  {info.data ? formatRinggit(info.data.balance) : '—'}
                </Text>
              </View>
            </Card>

            <Card style={styles.amountCard}>
              <Text style={styles.amountTitle}>Top-up amount</Text>
              <View style={styles.presets}>
                {PRESET_AMOUNTS.map((preset) => {
                  const selected = custom.trim() === '' && amount === preset;
                  return (
                    <Pressable
                      key={preset}
                      style={[styles.presetChip, selected && styles.presetChipSelected]}
                      onPress={() => {
                        setAmount(preset);
                        setCustom('');
                      }}
                      accessibilityRole="button"
                    >
                      <Text
                        style={[styles.presetChipText, selected && styles.presetChipTextSelected]}
                      >
                        RM{formatThousands(preset)}
                      </Text>
                    </Pressable>
                  );
                })}
              </View>
              <TextField
                label="Custom amount"
                value={custom}
                onChangeText={setCustom}
                placeholder="Enter amount"
                keyboardType="decimal-pad"
              />
              <Button title="Continue" onPress={continueToPayment} disabled={!canContinue} />
            </Card>

            <Text style={styles.recordsTitle}>Top-up records</Text>
          </View>
        }
        renderItem={({ item }) => <TopupRow item={item} />}
      />
    </Screen>
  );
}

function TopupRow({ item }: { item: MerchantTopupItem }) {
  const status = topupStatusMeta(item.status);
  return (
    <View style={styles.row}>
      <View style={styles.rowTexts}>
        <Text style={styles.rowTitle}>{formatRinggit(item.amount)}</Text>
        <Text style={styles.rowMeta}>
          {item.payment_method.toUpperCase()} · {formatSimpleDate(item.created_at)}
        </Text>
      </View>
      <StatusTag label={status.label} status={status.tag} />
    </View>
  );
}

const styles = StyleSheet.create({
  listContent: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  header: {
    gap: spacing.md,
    marginBottom: spacing.sm,
  },
  balanceCard: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  balanceIcon: {
    width: 40,
    height: 40,
  },
  balanceLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  balanceValue: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
    marginTop: 2,
  },
  amountCard: {
    gap: spacing.md,
  },
  amountTitle: {
    ...textStyles.heading3,
  },
  presets: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm,
  },
  presetChip: {
    borderWidth: 1,
    borderColor: coreColors.borderLight,
    borderRadius: 8,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  presetChipSelected: {
    borderColor: coreColors.brandBlueLight,
    backgroundColor: coreColors.tintBlue,
  },
  presetChipText: {
    ...textStyles.body,
    color: coreColors.blackText,
  },
  presetChipTextSelected: {
    color: coreColors.brandBlueLight,
    fontWeight: '700',
  },
  recordsTitle: {
    ...textStyles.heading3,
    marginTop: spacing.sm,
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
});
