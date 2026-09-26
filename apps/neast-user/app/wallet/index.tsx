import { useLayoutEffect, useState } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router, useNavigation } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { PRESET_AMOUNTS } from '@neast/constant';
import { formatRinggit, type FpxBank } from '@neast/types';
import {
  Card,
  Chevron,
  FpxBankPicker,
  PaymentMethodSection,
  SlidePayButton,
  spacing,
  TextField,
  Toast,
  userHomeColors,
  PageHeader,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { openH5WebView } from '@/lib/callbacks';
import { createWalletTopup, getPaymentQuote, getWalletBalance } from '@/lib/endpoints';
import { buildPaymentMethodOptions, fiuuChannelFor } from '@/lib/payment-methods';
import { Screen } from '@/components/Screen';

/** Wallet top-up: balance, presets, payment method, then Fiuu H5. */
export default function WalletRoute() {
  const insets = useSafeAreaInsets();
  const navigation = useNavigation();
  const queryClient = useQueryClient();

  const [amount, setAmount] = useState('');
  const [method, setMethod] = useState('fpx');
  const [bank, setBank] = useState<FpxBank | null>(null);
  const [bankPickerVisible, setBankPickerVisible] = useState(false);

  useLayoutEffect(() => {
    navigation.setOptions({ gestureEnabled: false });
  }, [navigation]);

  const balance = useQuery({
    queryKey: ['wallet-balance'],
    queryFn: getWalletBalance,
  });

  const quote = useQuery({
    queryKey: ['payment-quote', amount],
    queryFn: () => getPaymentQuote(amount),
    enabled: Number(amount) >= 1.01,
  });

  const total = quote.data?.methods[method]?.total_amount;

  const payMutation = useMutation({
    mutationFn: () =>
      createWalletTopup({
        amount,
        payment_method: method,
        payment_channel: fiuuChannelFor(method, bank?.channel),
      }),
    onSuccess: (order) => {
      openH5WebView(order.payment_url, 'Wallet Top-Up', {
        onResult: (result) => {
          if (result === 'success') {
            void queryClient.invalidateQueries({ queryKey: ['wallet-balance'] });
            void queryClient.invalidateQueries({ queryKey: ['wallet-topups'] });
            Alert.alert('Top-up successful', 'Your wallet balance has been updated.');
          } else if (result === 'pending') {
            Toast.info('Payment is pending');
          } else {
            Toast.error('Payment failed');
          }
        },
        onCancel: () => Toast.info('Payment cancelled'),
      });
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const submit = () => {
    if (method === 'fpx' && !bank) {
      setBankPickerVisible(true);
      return false;
    }
    payMutation.mutate();
    return true;
  };

  return (
    <Screen edges={[]}>
      <PageHeader title="Wallet" />
      <View style={styles.flex}>
        <ScrollView
          keyboardShouldPersistTaps="handled"
          contentContainerStyle={[styles.body, { paddingBottom: insets.bottom + 78 }]}
        >
          <View style={styles.balanceCard}>
            <View style={styles.balanceRow}>
              <Text style={styles.balanceLabel}>Balance</Text>
              <Pressable
                accessibilityRole="button"
                onPress={() => router.push('/wallet/history')}
                hitSlop={8}
                style={({ pressed }) => [styles.historyLink, pressed && styles.pressed]}
              >
                <Text style={styles.historyText}>Top-up history</Text>
                <Chevron direction="right" color={userHomeColors.textOnNavy} size={8} />
              </Pressable>
            </View>
            <Text style={styles.balanceValue}>
              {balance.isSuccess ? formatRinggit(balance.data.balance) : '—'}
            </Text>
          </View>

          <Card style={styles.topupCard}>
            <Text style={styles.sectionTitle}>Top up</Text>
            <TextField
              value={amount}
              onChangeText={setAmount}
              keyboardType="decimal-pad"
              placeholder="0.00"
              left={<Text style={styles.amountPrefix}>RM</Text>}
              inputStyle={styles.amountInput}
            />
            <View style={styles.presetRow}>
              {PRESET_AMOUNTS.map((preset) => {
                const selected = amount === String(preset);
                return (
                  <Pressable
                    key={preset}
                    style={[styles.presetChip, selected && styles.presetChipActive]}
                    onPress={() => setAmount(String(preset))}
                    accessibilityRole="button"
                    accessibilityState={{ selected }}
                  >
                    <Text style={[styles.presetText, selected && styles.presetTextActive]}>
                      {preset}
                    </Text>
                  </Pressable>
                );
              })}
            </View>
          </Card>

          <PaymentMethodSection
            methods={buildPaymentMethodOptions(quote.data).map((item) =>
              item.id === 'fpx'
                ? {
                    ...item,
                    below: (
                      <Pressable
                        accessibilityRole="button"
                        onPress={() => {
                          setMethod('fpx');
                          setBankPickerVisible(true);
                        }}
                        style={styles.bankRow}
                      >
                        <Text style={styles.bankText}>{bank ? bank.name : 'Select bank'}</Text>
                        <Chevron direction="right" color={userHomeColors.navy} size={8} />
                      </Pressable>
                    ),
                  }
                : item,
            )}
            selectedId={method}
            onSelect={(id) => {
              setMethod(id);
              if (id === 'fpx' && !bank) {
                setBankPickerVisible(true);
              }
            }}
          />
        </ScrollView>
        <SlidePayButton
          title={total ? `Slide to pay ${formatRinggit(total)}` : 'Slide to pay'}
          bottom={insets.bottom + 16}
          disabled={!total}
          loading={payMutation.isPending}
          onConfirm={submit}
        />
      </View>

      <FpxBankPicker
        visible={bankPickerVisible}
        onClose={() => setBankPickerVisible(false)}
        onSelect={setBank}
        selectedChannel={bank?.channel}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  flex: {
    flex: 1,
  },
  body: {
    padding: spacing.lg,
    gap: spacing.lg,
  },
  balanceCard: {
    backgroundColor: userHomeColors.navy,
    borderRadius: 16,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.lg,
    gap: spacing.xs,
  },
  balanceRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  balanceLabel: {
    color: userHomeColors.gold,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '600',
  },
  balanceValue: {
    color: userHomeColors.surface,
    fontSize: 32,
    lineHeight: 40,
    fontWeight: '700',
  },
  historyLink: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  pressed: {
    opacity: 0.7,
  },
  historyText: {
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '600',
    color: userHomeColors.textOnNavy,
  },
  topupCard: {
    gap: spacing.md,
    borderRadius: 16,
  },
  sectionTitle: {
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
    color: userHomeColors.textSecondary,
  },
  amountPrefix: {
    color: userHomeColors.navy,
    fontSize: 16,
    lineHeight: 22,
    fontWeight: '700',
    marginRight: spacing.xs,
  },
  amountInput: {
    fontSize: 18,
    fontWeight: '700',
    color: userHomeColors.textPrimary,
  },
  presetRow: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  presetChip: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 10,
    borderRadius: 999,
    backgroundColor: userHomeColors.lightBlue,
  },
  presetChipActive: {
    backgroundColor: userHomeColors.navy,
  },
  presetText: {
    fontSize: 13,
    lineHeight: 18,
    fontWeight: '600',
    color: userHomeColors.navy,
  },
  presetTextActive: {
    color: userHomeColors.surface,
  },
  bankRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.md,
    paddingBottom: spacing.md,
  },
  bankText: {
    color: userHomeColors.navy,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '700',
  },
});
