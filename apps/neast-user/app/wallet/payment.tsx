import { useState } from 'react';
import { Alert, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { formatRinggit, type FpxBank, type PaymentQuote } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  FpxBankPicker,
  PaymentMethodSection,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { openH5WebView } from '../../src/lib/callbacks';
import { createWalletTopup, getPaymentQuote } from '../../src/lib/endpoints';
import { buildLocalPaymentQuote, totalForMethod } from '../../src/lib/format';
import { useAppConfig } from '../../src/hooks/use-profile';
import { buildPaymentMethodOptions, fiuuChannelFor } from '../../src/lib/payment-methods';
import { Screen } from '../../src/components/Screen';

/**
 * Wallet payment (wallet_payment_screen parity): quote + method + FPX bank →
 * POST /app/wallet/topup/create → H5 webview → success dialog.
 */
export default function WalletPaymentRoute() {
  const params = useLocalSearchParams<{ amount: string; amountLabel: string }>();
  // WalletPaymentArgs parity: default RM 500 when no amount is passed.
  const amount = params.amount ?? '500.00';
  const queryClient = useQueryClient();
  const appConfig = useAppConfig();

  const [method, setMethod] = useState('fpx');
  const [bank, setBank] = useState<FpxBank | null>(null);
  const [bankPickerVisible, setBankPickerVisible] = useState(false);

  const quote = useQuery({
    queryKey: ['payment-quote', amount],
    queryFn: () => getPaymentQuote(amount),
  });

  // paymentQuoteProvider parity: fall back to a locally computed quote on error.
  const effectiveQuote: PaymentQuote | undefined =
    quote.data ??
    (quote.isError
      ? buildLocalPaymentQuote(amount, appConfig.data?.payment_processing_fees ?? {})
      : undefined);

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
            Alert.alert('Top-up successful', 'Your wallet balance has been updated.', [
              { text: 'OK', onPress: () => router.back() },
            ]);
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
      return;
    }
    payMutation.mutate();
  };

  const total = totalForMethod(effectiveQuote, method, amount);

  return (
    <Screen>
      <BrandHeader title="Payment" onBack={() => router.back()} />
      <View style={styles.body}>
        <Card style={styles.summaryCard}>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Top-up amount</Text>
            <Text style={styles.summaryValue}>{params.amountLabel ?? formatRinggit(amount)}</Text>
          </View>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Total to pay</Text>
            <Text style={styles.summaryTotal}>{formatRinggit(total)}</Text>
          </View>
        </Card>

        <PaymentMethodSection
          methods={buildPaymentMethodOptions(effectiveQuote)}
          selectedId={method}
          onSelect={(id) => {
            setMethod(id);
            if (id === 'fpx' && !bank) {
              setBankPickerVisible(true);
            }
          }}
        />

        {method === 'fpx' ? (
          <Button
            title={bank ? `Bank: ${bank.name}` : 'Select Bank'}
            variant="outline"
            onPress={() => setBankPickerVisible(true)}
          />
        ) : null}

        <Button
          title={`Pay ${formatRinggit(total)}`}
          onPress={submit}
          loading={payMutation.isPending}
          style={styles.payButton}
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
  body: {
    flex: 1,
    padding: spacing.lg,
    gap: spacing.lg,
  },
  summaryCard: {
    gap: spacing.sm,
  },
  summaryRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  summaryLabel: {
    ...textStyles.body,
    color: coreColors.textSecondary,
  },
  summaryValue: {
    ...textStyles.body,
    fontWeight: '600',
  },
  summaryTotal: {
    ...textStyles.heading3,
    color: coreColors.brandBlue,
  },
  payButton: {
    marginTop: 'auto',
  },
});
