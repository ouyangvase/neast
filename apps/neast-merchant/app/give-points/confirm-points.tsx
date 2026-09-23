import { useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import { formatRinggit, formatThousands, type ConfirmGivePointsBody } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  EmptyState,
  spacing,
  TextField,
  textStyles,
  Toast,
  useUiTheme,
} from '@neast/ui-mobile';

import successImage from '../../assets/images/give_points/success.png';

import { apiErrorMessage } from '../../src/lib/api';
import { getConfirmPointsArgs, openScanner } from '../../src/lib/callbacks';
import { confirmGivePoints, getGivePointsCustomer } from '../../src/lib/endpoints';
import { useMerchantInfo } from '../../src/hooks/use-merchant';
import { Screen } from '../../src/components/Screen';
import { SuccessDialog } from '../../src/components/SuccessDialog';

/**
 * Confirm points (confirm_points_screen parity) — Step 2: identify the
 * customer by phone input or customer QR scan (`{"user_id": n}` JSON →
 * GET /merchant/give-points/customer fills the phone), then confirm.
 */
export default function ConfirmPointsRoute() {
  const theme = useUiTheme();
  const args = getConfirmPointsArgs();
  const info = useMerchantInfo();
  const queryClient = useQueryClient();
  const [phone, setPhone] = useState('');
  const [phoneError, setPhoneError] = useState<string | undefined>(undefined);
  const [successVisible, setSuccessVisible] = useState(false);

  const customerMutation = useMutation({
    mutationFn: (userId: number) => getGivePointsCustomer(userId),
    onSuccess: (data) => setPhone(data.account),
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const confirmMutation = useMutation({
    mutationFn: (body: ConfirmGivePointsBody) => confirmGivePoints(body),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['give-points'] });
      setSuccessVisible(true);
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  /** Customer QR payload: JSON `{"user_id": <int or numeric string>}`. */
  const handleCustomerScan = (value: string) => {
    let userId = NaN;
    try {
      userId = Number((JSON.parse(value) as { user_id?: unknown })?.user_id);
    } catch {
      // not JSON — handled below
    }
    if (!Number.isInteger(userId) || userId < 1) {
      Toast.error('Invalid customer QR code');
      return;
    }
    customerMutation.mutate(userId);
  };

  if (!args) {
    return (
      <Screen>
        <BrandHeader title="Confirm Points" onBack={() => router.back()} />
        <EmptyState
          title="Nothing to confirm"
          message="Start from the Give Points tab to capture a receipt."
          actionLabel="Go back"
          onAction={() => router.back()}
          style={styles.missing}
        />
      </Screen>
    );
  }

  const merchantId = info.data?.id;

  const confirm = () => {
    const customer = phone.trim();
    if (!customer) {
      setPhoneError('Enter the customer phone or scan their QR');
      return;
    }
    if (!merchantId) {
      return;
    }
    confirmMutation.mutate({
      customer,
      amount: args.amount,
      points: args.points,
      merchant_id: merchantId,
      notes: args.notes || undefined,
      receipt_number: args.receiptNumber || undefined,
      receipt_path: args.receiptPath,
    });
  };

  return (
    <Screen>
      <BrandHeader title="Confirm Points" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.content}>
        <Card style={styles.summaryCard}>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Receipt amount</Text>
            <Text style={styles.summaryValue}>{formatRinggit(args.amount)}</Text>
          </View>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Points to award</Text>
            <Text style={styles.summaryPoints}>{formatThousands(args.points)} pts</Text>
          </View>
          {args.receiptNumber ? (
            <View style={styles.summaryRow}>
              <Text style={styles.summaryLabel}>Receipt number</Text>
              <Text style={styles.summaryValue}>{args.receiptNumber}</Text>
            </View>
          ) : null}
        </Card>

        <LinearGradient colors={theme.gradients.highlight} style={styles.customerCard}>
          <Text style={styles.customerTitle}>Customer</Text>
          <Text style={styles.customerSubtitle}>
            Enter the customer phone number or scan their NEAST QR
          </Text>
          <View style={styles.customerForm}>
            <TextField
              value={phone}
              onChangeText={(value) => {
                setPhone(value);
                setPhoneError(undefined);
              }}
              placeholder="e.g. 60123456789"
              keyboardType="phone-pad"
              error={phoneError}
              containerStyle={styles.customerField}
            />
            <Button
              title="Scan QR"
              variant="secondary"
              fullWidth={false}
              onPress={() => openScanner(handleCustomerScan)}
              loading={customerMutation.isPending}
            />
          </View>
        </LinearGradient>

        <Button
          title={`Give ${formatThousands(args.points)} points`}
          onPress={confirm}
          loading={confirmMutation.isPending}
          disabled={!merchantId}
        />
      </ScrollView>

      <SuccessDialog
        visible={successVisible}
        image={successImage}
        title="Points given"
        message={`${formatThousands(args.points)} points awarded to ${phone.trim()}.`}
        onClose={() => {
          setSuccessVisible(false);
          router.dismissTo('/');
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
  summaryPoints: {
    ...textStyles.heading3,
    color: coreColors.darkGreen,
  },
  customerCard: {
    borderRadius: 12,
    padding: spacing.lg,
    gap: spacing.sm,
  },
  customerTitle: {
    ...textStyles.heading3,
    color: coreColors.white,
  },
  customerSubtitle: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    opacity: 0.85,
  },
  customerForm: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: spacing.sm,
    marginTop: spacing.xs,
  },
  customerField: {
    flex: 1,
  },
});
