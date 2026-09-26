import { useEffect, useLayoutEffect, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Redirect, router, useNavigation } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { formatRinggit, type FpxBank } from '@neast/types';
import {
  Card,
  Chevron,
  FpxBankPicker,
  JourneyBar,
  PaymentMethodSection,
  SlidePayButton,
  spacing,
  TextField,
  Toast,
  userHomeColors,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { openH5WebView } from '../../src/lib/callbacks';
import {
  createWalletTopup,
  getPaymentQuote,
  getWalletBalance,
  payRentByWallet,
} from '../../src/lib/endpoints';
import { buildPaymentMethodOptions, fiuuChannelFor } from '../../src/lib/payment-methods';
import { useSelectionStore } from '../../src/stores/selection';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';

/**
 * Rent is always paid from wallet credit. A short balance is topped up first
 * (default rent − balance); a covered balance skips the provider.
 */
export default function PayRentPaymentRoute() {
  const insets = useSafeAreaInsets();
  const navigation = useNavigation();
  const rent = useSelectionStore((state) => state.rent);
  const queryClient = useQueryClient();

  const [method, setMethod] = useState('fpx');
  const [bank, setBank] = useState<FpxBank | null>(null);
  const [bankPickerVisible, setBankPickerVisible] = useState(false);
  const [topupAmount, setTopupAmount] = useState('');
  const [topupEdited, setTopupEdited] = useState(false);
  const [processing, setProcessing] = useState(false);

  const balance = useQuery({ queryKey: ['wallet-balance'], queryFn: getWalletBalance });

  const shortfall =
    rent && balance.isSuccess ? Number(rent.amount) - Number(balance.data.balance) : null;
  const toppingUp = shortfall !== null && shortfall > 0;

  const quote = useQuery({
    queryKey: ['payment-quote', topupAmount],
    queryFn: () => getPaymentQuote(topupAmount),
    enabled: toppingUp && Number(topupAmount) >= 1.01,
  });

  useEffect(() => {
    if (shortfall === null || shortfall <= 0 || topupEdited) return;
    setTopupAmount(Math.max(shortfall, 1.01).toFixed(2));
  }, [shortfall, topupEdited]);

  useLayoutEffect(() => {
    navigation.setOptions({ gestureEnabled: false });
  }, [navigation]);

  const payFromWallet = async () => {
    setProcessing(true);
    try {
      const entry = await payRentByWallet(rent!.id);
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      await queryClient.invalidateQueries({ queryKey: ['rent-history'] });
      await queryClient.invalidateQueries({ queryKey: ['wallet-balance'] });
      useSelectionStore.getState().setHistory(entry);
      router.replace('/pay-rent/history/detail');
    } catch (error) {
      Toast.error(apiErrorMessage(error));
    } finally {
      setProcessing(false);
    }
  };

  const applyTopup = async () => {
    setProcessing(true);
    try {
      const wallet = await getWalletBalance();
      queryClient.setQueryData(['wallet-balance'], wallet);
      if (Number(wallet.balance) >= Number(rent!.amount)) {
        await payFromWallet();
        return;
      }
      setTopupEdited(false);
      Toast.info('Wallet topped up. Add more credit to cover this rent.');
    } catch (error) {
      Toast.error(apiErrorMessage(error));
    } finally {
      setProcessing(false);
    }
  };

  const topupMutation = useMutation({
    mutationFn: () =>
      createWalletTopup({
        amount: topupAmount,
        payment_method: method,
        payment_channel: fiuuChannelFor(method, bank?.channel),
      }),
    onSuccess: (order) => {
      openH5WebView(order.payment_url, 'Wallet Top-Up', {
        onResult: (result) => {
          if (result === 'success') {
            void applyTopup();
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

  if (!rent) {
    return <Redirect href="/" />;
  }

  const coverHint =
    shortfall !== null && shortfall > 0 && topupAmount !== '' && Number(topupAmount) < shortfall
      ? `At least ${formatRinggit(shortfall)} covers this rent.`
      : null;

  const submit = () => {
    if (!toppingUp) {
      void payFromWallet();
      return true;
    }
    if (Number(topupAmount) < 1.01) {
      Toast.error('Amount must be at least 1.01');
      return false;
    }
    if (method === 'fpx' && !bank) {
      setBankPickerVisible(true);
      return false;
    }
    topupMutation.mutate();
    return true;
  };

  const total = toppingUp ? quote.data?.methods[method]?.total_amount : rent.amount;

  return (
    <Screen edges={[]}>
      <PageHeader title="Pay Rent" />
      <JourneyBar steps={['Top up', 'Pay']} activeIndex={balance.isSuccess && !toppingUp ? 1 : 0} />
      <View style={styles.flex}>
        <ScrollView
          keyboardShouldPersistTaps="handled"
          contentContainerStyle={[styles.body, { paddingBottom: insets.bottom + 78 }]}
        >
          <Card style={styles.summaryCard}>
            <Text style={styles.property} numberOfLines={1}>
              {rent.property_name}
            </Text>
            <View style={styles.summaryRow}>
              <Text style={styles.summaryLabel}>Rent amount</Text>
              <Text style={styles.summaryValue}>{formatRinggit(rent.amount)}</Text>
            </View>
            <View style={styles.summaryRow}>
              <Text style={styles.summaryLabel}>Wallet credit</Text>
              <Text style={styles.summaryValue}>
                {balance.isSuccess ? formatRinggit(balance.data.balance) : '—'}
              </Text>
            </View>
          </Card>

          {toppingUp ? (
            <>
              <TextField
                label="Top-up amount (RM)"
                value={topupAmount}
                onChangeText={(value) => {
                  setTopupEdited(true);
                  setTopupAmount(value);
                }}
                keyboardType="decimal-pad"
                right={
                  coverHint ? (
                    <Text numberOfLines={1} style={styles.amountHint}>
                      {coverHint}
                    </Text>
                  ) : null
                }
              />
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
            </>
          ) : null}
        </ScrollView>
        <SlidePayButton
          title={total ? `Slide to pay ${formatRinggit(total)}` : 'Slide to pay'}
          bottom={insets.bottom + 16}
          disabled={!balance.isSuccess || !total}
          loading={topupMutation.isPending || processing || balance.isLoading}
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
  summaryCard: {
    gap: spacing.sm,
  },
  property: {
    color: userHomeColors.textPrimary,
    fontSize: 15,
    lineHeight: 20,
    fontWeight: '600',
  },
  summaryRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  summaryLabel: {
    flex: 1,
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '600',
  },
  summaryValue: {
    flexShrink: 1,
    color: userHomeColors.textPrimary,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '700',
    textAlign: 'right',
  },
  amountHint: {
    textAlign: 'right',
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
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
