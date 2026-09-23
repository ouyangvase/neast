import { useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Redirect, router } from 'expo-router';
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
  TextField,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '../../src/lib/api';
import { openH5WebView } from '../../src/lib/callbacks';
import {
  createRentPayment,
  getPaymentQuote,
  getRentHistory,
  getWalletBalance,
  payRentByWallet,
} from '../../src/lib/endpoints';
import { buildLocalPaymentQuote, totalForMethod } from '../../src/lib/format';
import { isPaidHistory, type RentHistoryEntry } from '../../src/lib/types';
import { useAppConfig } from '../../src/hooks/use-profile';
import { buildPaymentMethodOptions, fiuuChannelFor } from '../../src/lib/payment-methods';
import { useSelectionStore } from '../../src/stores/selection';
import { Screen } from '../../src/components/Screen';

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

/**
 * `_waitForPaidHistory` parity: poll the rent history until the new entry is
 * paid/settled (≤5 tries, 1s apart), then hand it to the status screen.
 */
async function waitForPaidHistory(rentId: number): Promise<RentHistoryEntry | null> {
  for (let attempt = 0; attempt < 5; attempt += 1) {
    const page = await getRentHistory({ rent_id: rentId, page: 1, limit: 10 });
    const paid = page.items.find((item) => isPaidHistory(item));
    if (paid) {
      return paid;
    }
    await sleep(1000);
  }
  return null;
}

/**
 * Rent payment (pay_rent_payment_screen parity): wallet balance or Fiuu H5;
 * owner-bank fields collected when the owner is unbound.
 */
export default function PayRentPaymentRoute() {
  const rent = useSelectionStore((state) => state.rent);
  const queryClient = useQueryClient();
  const appConfig = useAppConfig();

  const [method, setMethod] = useState('wallet');
  const [bank, setBank] = useState<FpxBank | null>(null);
  const [bankPickerVisible, setBankPickerVisible] = useState(false);
  const [ownerBankName, setOwnerBankName] = useState('');
  const [ownerBankAccount, setOwnerBankAccount] = useState('');
  const [ownerAccountHolder, setOwnerAccountHolder] = useState('');
  const [processing, setProcessing] = useState(false);

  const balance = useQuery({ queryKey: ['wallet-balance'], queryFn: getWalletBalance });
  const quote = useQuery({
    queryKey: ['payment-quote', rent?.amount ?? '0'],
    queryFn: () => getPaymentQuote(rent!.amount),
    enabled: !!rent,
  });

  if (!rent) {
    // No deep-link entry point for this screen — bounce back to the tab shell.
    return <Redirect href="/" />;
  }

  const effectiveQuote: PaymentQuote | undefined =
    quote.data ??
    (quote.isError
      ? buildLocalPaymentQuote(rent.amount, appConfig.data?.payment_processing_fees ?? {})
      : undefined);

  const ownerUnbound = !rent.landlord_id;
  const ownerFields = ownerUnbound
    ? {
        owner_bank_name: ownerBankName.trim() || undefined,
        owner_bank_account: ownerBankAccount.trim() || undefined,
        owner_account_holder: ownerAccountHolder.trim() || undefined,
      }
    : {};

  const finishWithHistory = async () => {
    setProcessing(true);
    try {
      const entry = await waitForPaidHistory(rent.id);
      await queryClient.invalidateQueries({ queryKey: ['rent-list'] });
      await queryClient.invalidateQueries({ queryKey: ['rent-history'] });
      if (entry) {
        useSelectionStore.getState().setHistory(entry);
        router.replace('/pay-rent/history/detail');
      } else {
        Toast.info('Payment is being processed');
        router.back();
      }
    } finally {
      setProcessing(false);
    }
  };

  const payMutation = useMutation({
    mutationFn: async () => {
      if (method === 'wallet') {
        await payRentByWallet(rent.id, ownerFields);
        return { h5: false as const };
      }
      const order = await createRentPayment({
        rent_id: rent.id,
        payment_method: method,
        payment_channel: fiuuChannelFor(method, bank?.channel),
        ...ownerFields,
      });
      return { h5: true as const, paymentUrl: order.payment_url };
    },
    onSuccess: (result) => {
      if (!result.h5) {
        void finishWithHistory();
        return;
      }
      if (!result.paymentUrl) {
        // Already-paid race — poll for the paid entry instead.
        void finishWithHistory();
        return;
      }
      openH5WebView(result.paymentUrl, 'Rent Payment', {
        onResult: (h5Result) => {
          if (h5Result === 'success') {
            void finishWithHistory();
          } else if (h5Result === 'pending') {
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

  const total =
    method === 'wallet' ? rent.amount : totalForMethod(effectiveQuote, method, rent.amount);

  return (
    <Screen>
      <BrandHeader title="Pay Rent" onBack={() => router.back()} />
      <View style={styles.body}>
        <Card style={styles.summaryCard}>
          <Text style={styles.property} numberOfLines={1}>
            {rent.property_name}
          </Text>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Rent amount</Text>
            <Text style={styles.summaryValue}>{formatRinggit(rent.amount)}</Text>
          </View>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Total to pay</Text>
            <Text style={styles.summaryTotal}>{formatRinggit(total)}</Text>
          </View>
          {rent.earn_points > 0 ? (
            <Text style={styles.pointsHint}>Earn {rent.earn_points} points on this payment</Text>
          ) : null}
        </Card>

        <PaymentMethodSection
          methods={buildPaymentMethodOptions(effectiveQuote, {
            includeWallet: true,
            walletBalance: balance.data?.balance,
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

        {ownerUnbound ? (
          <Card style={styles.ownerCard}>
            <Text style={styles.ownerTitle}>Owner payout details</Text>
            <Text style={styles.ownerHint}>
              The owner hasn&apos;t linked their account yet — tell us where to send the payout.
            </Text>
            <TextField label="Bank name" value={ownerBankName} onChangeText={setOwnerBankName} />
            <TextField
              label="Account number"
              value={ownerBankAccount}
              onChangeText={setOwnerBankAccount}
              keyboardType="number-pad"
            />
            <TextField
              label="Account holder"
              value={ownerAccountHolder}
              onChangeText={setOwnerAccountHolder}
            />
          </Card>
        ) : null}

        <Button
          title={`Pay ${formatRinggit(total)}`}
          onPress={submit}
          loading={payMutation.isPending || processing}
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
  property: {
    ...textStyles.heading3,
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
  pointsHint: {
    ...textStyles.caption,
    color: coreColors.darkGreen,
  },
  ownerCard: {
    gap: spacing.md,
  },
  ownerTitle: {
    ...textStyles.heading3,
  },
  ownerHint: {
    ...textStyles.caption,
  },
  payButton: {
    marginTop: 'auto',
  },
});
