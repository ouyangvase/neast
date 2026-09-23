import { useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useMutation } from '@tanstack/react-query';

import { formatRinggit, formatSimpleDate } from '@neast/types';
import {
  BrandHeader,
  Button,
  Card,
  coreColors,
  EmptyState,
  spacing,
  textStyles,
  Toast,
} from '@neast/ui-mobile';

import successImage from '../assets/images/redeem/success.png';

import { apiErrorMessage } from '../src/lib/api';
import { getRedeemVoucherArgs } from '../src/lib/callbacks';
import { redeemCoupon } from '../src/lib/endpoints';
import { Screen } from '../src/components/Screen';
import { SuccessDialog } from '../src/components/SuccessDialog';

/** Confirm Redeem (redeem_voucher_screen parity): voucher card + detail card + confirm. */
export default function RedeemVoucherRoute() {
  const args = getRedeemVoucherArgs();
  const [successVisible, setSuccessVisible] = useState(false);

  const redeemMutation = useMutation({
    mutationFn: (code: string) => redeemCoupon(code),
    onSuccess: () => setSuccessVisible(true),
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  if (!args) {
    return (
      <Screen>
        <BrandHeader title="Confirm Redeem" onBack={() => router.back()} />
        <EmptyState
          title="No voucher selected"
          message="Scan or enter a voucher code from the Scan tab."
          actionLabel="Go back"
          onAction={() => router.back()}
          style={styles.missing}
        />
      </Screen>
    );
  }

  const { preview, code } = args;

  return (
    <Screen>
      <BrandHeader title="Confirm Redeem" onBack={() => router.back()} />
      <ScrollView contentContainerStyle={styles.content}>
        <Card style={styles.voucherCard}>
          <Text style={styles.voucherName}>{preview.name}</Text>
          <Text style={styles.voucherDiscount}>{formatRinggit(preview.discount_amount)}</Text>
          <Text style={styles.voucherMeta}>
            {preview.used_points} points · SN {preview.sn}
          </Text>
        </Card>

        <View style={styles.validBanner}>
          <Text style={styles.validBannerText}>This voucher is valid</Text>
        </View>

        <Card style={styles.detailCard}>
          <DetailRow label="Customer" value={preview.customer_name} />
          <DetailRow label="Contact" value={preview.contact} />
          <DetailRow label="Valid at" value={preview.merchant_names.join(', ')} />
          <DetailRow
            label="Expires"
            value={preview.expire_at ? formatSimpleDate(preview.expire_at) : 'No expiry'}
          />
        </Card>

        <Button
          title="Confirm Redeem"
          onPress={() => redeemMutation.mutate(code)}
          loading={redeemMutation.isPending}
        />
      </ScrollView>

      <SuccessDialog
        visible={successVisible}
        image={successImage}
        title="Voucher redeemed"
        message={`${preview.name} has been redeemed for ${preview.customer_name}.`}
        onClose={() => {
          setSuccessVisible(false);
          router.back();
        }}
      />
    </Screen>
  );
}

function DetailRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.detailRow}>
      <Text style={styles.detailLabel}>{label}</Text>
      <Text style={styles.detailValue}>{value}</Text>
    </View>
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
  voucherCard: {
    alignItems: 'center',
    gap: spacing.xs,
  },
  voucherName: {
    ...textStyles.heading2,
    textAlign: 'center',
  },
  voucherDiscount: {
    ...textStyles.displayLarge,
    color: coreColors.brandBlue,
  },
  voucherMeta: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  validBanner: {
    backgroundColor: coreColors.tintGreen,
    borderRadius: 8,
    paddingVertical: spacing.sm,
    alignItems: 'center',
  },
  validBannerText: {
    ...textStyles.body,
    color: coreColors.darkGreen,
    fontWeight: '600',
  },
  detailCard: {
    gap: spacing.sm,
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: spacing.md,
  },
  detailLabel: {
    ...textStyles.body,
    color: coreColors.textSecondary,
  },
  detailValue: {
    ...textStyles.body,
    fontWeight: '500',
    flex: 1,
    textAlign: 'right',
  },
});
