import { useState } from 'react';
import { Alert, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { formatRinggit } from '@neast/types';
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
  type FpxBank,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { openH5WebView } from '../../src/lib/callbacks';
import { createWalletTopup } from '../../src/lib/endpoints';
import {
  buildPaymentMethodOptions,
  fiuuChannelFor,
  totalWithFee,
} from '../../src/lib/payment-methods';
import { useMerchantConfig } from '../../src/hooks/use-merchant';
import { Screen } from '../../src/components/Screen';

/**
 * Wallet payment (wallet_payment_screen parity): payment method (no wallet
 * option) + FPX bank → POST /merchant/wallet/topup/create → H5 WebView.
 */
export default function WalletPaymentRoute() {
  const params = useLocalSearchParams<{ amount: string }>();
  // WalletPaymentArgs parity: default RM 500 when no amount is passed.
  const amount = params.amount ?? '500';
  const queryClient = useQueryClient();
  const config = useMerchantConfig();

  const [method, setMethod] = useState('fpx');
  const [bank, setBank] = useState<FpxBank | null>(null);
  const [bankPickerVisible, setBankPickerVisible] = useState(false);

  const fees = config.data?.payment_processing_fees;
  const total = totalWithFee(amount, fees, method);

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
            void queryClient.invalidateQueries({ queryKey: ['merchant-info'] });
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

  return (
    <Screen>
      <BrandHeader title="Payment" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.content}>
        <Card style={styles.summaryCard}>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Top-up amount</Text>
            <Text style={styles.summaryValue}>{formatRinggit(amount)}</Text>
          </View>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Total to pay</Text>
            <Text style={styles.summaryTotal}>{formatRinggit(total)}</Text>
          </View>
        </Card>

        <PaymentMethodSection
          methods={buildPaymentMethodOptions(fees)}
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
        />
      </ScrollView>

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
  content: {
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
});
