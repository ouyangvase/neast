import { Image, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import { formatRinggit, formatSimpleDate } from '@neast/types';
import { Button, Card, coreColors, spacing, textStyles } from '@neast/ui-mobile';

import { useSelectionStore } from '@/stores/selection';
import {
  CouponQrDialog,
  couponValidityLabel,
  useCouponActions,
} from '@/features/coupon/components';
import { ErrorState } from '@/components/StateViews';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';

/**
 * Coupon detail (coupon_detail_screen parity). The coupon arrives via the
 * selection store (go_router `extra` parity) — every entry point (catalog,
 * merchant sheet, my-vouchers) sets it before pushing.
 */
export default function CouponDetailRoute() {
  const coupon = useSelectionStore((state) => state.coupon);
  const couponActions = useCouponActions();

  return (
    <Screen edges={[]}>
      <PageHeader title="Voucher" />
      {!coupon ? (
        <ErrorState message="Voucher unavailable." onRetry={() => router.back()} />
      ) : (
        <ScrollView contentContainerStyle={styles.scroll}>
          <Image source={{ uri: coupon.image }} style={styles.hero} resizeMode="cover" />
          <View style={styles.body}>
            <Text style={styles.name}>{coupon.name}</Text>
            <Text style={styles.points}>{coupon.required_points} points</Text>

            <Card style={styles.infoCard}>
              <InfoRow label="Discount" value={`${formatRinggit(coupon.discount_amount)} off`} />
              <InfoRow label="Validity" value={couponValidityLabel(coupon)} />
              {coupon.expire_at ? (
                <InfoRow label="Expires" value={formatSimpleDate(coupon.expire_at)} />
              ) : null}
              {coupon.merchant_names.length > 0 ? (
                <InfoRow label="Redeemable at" value={coupon.merchant_names.join(', ')} />
              ) : null}
            </Card>

            {coupon.usage_condition ? (
              <View style={styles.terms}>
                <Text style={styles.termsTitle}>Terms</Text>
                <Text style={styles.termsBody}>{coupon.usage_condition}</Text>
              </View>
            ) : null}
          </View>

          <View style={styles.footer}>
            {coupon.action_status === 'redeem' ? (
              <Button
                title={`Redeem for ${coupon.required_points} pts`}
                onPress={() => couponActions.confirmRedeem(coupon)}
                loading={couponActions.redeeming}
              />
            ) : coupon.action_status === 'use_now' ? (
              <Button title="Use Now" onPress={() => couponActions.showQr(coupon)} />
            ) : (
              <Button title="Fully Redeemed" disabled onPress={() => undefined} />
            )}
          </View>
        </ScrollView>
      )}

      <CouponQrDialog
        coupon={couponActions.qrCoupon}
        visible={!!couponActions.qrCoupon}
        onClose={couponActions.closeQr}
      />
    </Screen>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: {
    paddingBottom: spacing.xxl,
    flexGrow: 1,
  },
  hero: {
    width: '100%',
    height: 180,
    backgroundColor: coreColors.divider,
  },
  body: {
    padding: spacing.lg,
    gap: spacing.md,
  },
  name: {
    ...textStyles.heading2,
  },
  points: {
    ...textStyles.body,
    color: coreColors.brandBlue,
    fontWeight: '700',
  },
  infoCard: {
    gap: spacing.sm,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  infoLabel: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  infoValue: {
    ...textStyles.bodySmall,
    fontWeight: '500',
    flexShrink: 1,
    textAlign: 'right',
  },
  terms: {
    gap: spacing.xs,
  },
  termsTitle: {
    ...textStyles.heading3,
  },
  termsBody: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  footer: {
    padding: spacing.lg,
    marginTop: 'auto',
  },
});
