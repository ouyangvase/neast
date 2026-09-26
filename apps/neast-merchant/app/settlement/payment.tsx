import { useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { formatRinggit, useIsLoggedIn } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  EmptyState,
  FpxBankPicker,
  PaymentMethodSection,
  spacing,
  textStyles,
  Toast,
  type FpxBank,
} from '@neast/ui-mobile';

import successImage from '@assets/images/settlement/success.png';

import { apiErrorMessage } from '@/lib/api';
import { openH5WebView } from '@/lib/callbacks';
import {
  createSettlementPayment,
  getSettlementOverview,
  paySettlementByWallet,
} from '@/lib/endpoints';
import { settlementDueLabel } from '@/lib/format';
import {
  buildPaymentMethodOptions,
  fiuuChannelFor,
  totalWithFee,
} from '@/lib/payment-methods';
import { useMerchantConfig, useMerchantInfo } from '@/hooks/use-merchant';
import { Screen } from '@/components/Screen';
import { SuccessDialog } from '@/components/SuccessDialog';

/**
 * Settlement payment (settlement_payment_screen parity): FPX (bank picker),
 * TNG, Grab, Visa/Master or Wallet. Fees come from /merchant/config; wallet
 * pays instantly from the balance, the rest go through the Fiuu H5 WebView.
 */
export default function SettlementPaymentRoute() {
  const isLoggedIn = useIsLoggedIn();
  const queryClient = useQueryClient();
  const info = useMerchantInfo();
  const config = useMerchantConfig();
  const [method, setMethod] = useState('wallet');
  const [bank, setBank] = useState<FpxBank | null>(null);
  const [bankPickerVisible, setBankPickerVisible] = useState(false);
  const [successVisible, setSuccessVisible] = useState(false);

  const overview = useQuery({
    queryKey: ['settlement-overview'],
    queryFn: getSettlementOverview,
    enabled: isLoggedIn,
  });

  const bill = overview.data;
  const fees = config.data?.payment_processing_fees;

  const refreshAfterPay = () => {
    void queryClient.invalidateQueries({ queryKey: ['settlement-overview'] });
    void queryClient.invalidateQueries({ queryKey: ['merchant-info'] });
  };

  const walletMutation = useMutation({
    mutationFn: (billId: number) => paySettlementByWallet(billId),
    onSuccess: () => {
      refreshAfterPay();
      setSuccessVisible(true);
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const h5Mutation = useMutation({
    mutationFn: (billId: number) =>
      createSettlementPayment({
        bill_id: billId,
        payment_method: method,
        payment_channel: fiuuChannelFor(method, bank?.channel),
      }),
    onSuccess: (order) => {
      openH5WebView(order.payment_url, 'Settlement Payment', {
        onResult: (result) => {
          if (result === 'success') {
            refreshAfterPay();
            setSuccessVisible(true);
          } else if (result === 'pending') {
            refreshAfterPay();
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

  if (!bill || bill.id === null) {
    return (
      <Screen>
        <BrandHeader title="Settlement Payment" onBack={() => router.back()} />
        <EmptyState
          title="No bill to pay"
          message="There is no outstanding settlement bill."
          actionLabel="Go back"
          onAction={() => router.back()}
          style={styles.missing}
        />
      </Screen>
    );
  }

  const billId = bill.id;
  const dueLabel = settlementDueLabel(bill.bill_month);
  const total = method === 'wallet' ? bill.amount : totalWithFee(bill.amount, fees, method);

  const submit = () => {
    if (method === 'wallet') {
      walletMutation.mutate(billId);
      return;
    }
    if (method === 'fpx' && !bank) {
      setBankPickerVisible(true);
      return;
    }
    h5Mutation.mutate(billId);
  };

  return (
    <Screen>
      <BrandHeader title="Settlement Payment" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.content}>
        <Card style={styles.summaryCard}>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Bill amount</Text>
            <Text style={styles.summaryValue}>{formatRinggit(bill.amount)}</Text>
          </View>
          {dueLabel ? (
            <View style={styles.summaryRow}>
              <Text style={styles.summaryLabel}>Due by</Text>
              <Text style={styles.summaryValue}>{dueLabel}</Text>
            </View>
          ) : null}
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Total to pay</Text>
            <Text style={styles.summaryTotal}>{formatRinggit(total)}</Text>
          </View>
        </Card>

        <PaymentMethodSection
          methods={buildPaymentMethodOptions(fees, {
            includeWallet: true,
            walletBalance: info.data?.balance,
          })}
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
          loading={walletMutation.isPending || h5Mutation.isPending}
        />
      </ScrollView>

      <FpxBankPicker
        visible={bankPickerVisible}
        onClose={() => setBankPickerVisible(false)}
        onSelect={setBank}
        selectedChannel={bank?.channel}
      />

      <SuccessDialog
        visible={successVisible}
        image={successImage}
        title="Settlement paid"
        message="Your settlement bill has been paid."
        onClose={() => {
          setSuccessVisible(false);
          router.back();
        }}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  missing: {
    flexGrow: 1,
    justifyContent: 'center',
  },
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
