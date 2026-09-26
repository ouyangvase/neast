import { useState } from 'react';
import { Image, Modal, StyleSheet, Text, View } from 'react-native';
import { useMutation, useQueryClient } from '@tanstack/react-query';

import type { CouponListItem, UserCouponItem } from '@neast/types';
import { formatRinggit, formatSimpleDate } from '@neast/types';
import {
  Button,
  Card,
  ConfirmDialog,
  coreColors,
  QrCodeView,
  radii,
  spacing,
  textStyles,
  Toast,
  userAccentColors,
} from '@neast/ui-mobile';

import { apiErrorMessage } from '@/lib/api';
import { redeemCoupon } from '@/lib/endpoints';

type AnyCoupon = CouponListItem | UserCouponItem;

/** Coupon catalog row (reward card parity). */
export function CouponCard({ coupon, onPress }: { coupon: AnyCoupon; onPress?: () => void }) {
  return (
    <Card onPress={onPress} style={styles.card} padded={false}>
      <Image source={{ uri: coupon.image }} style={styles.image} resizeMode="cover" />
      <View style={styles.body}>
        <Text style={styles.name} numberOfLines={2}>
          {coupon.name}
        </Text>
        {coupon.merchant_names.length > 0 ? (
          <Text style={styles.merchants} numberOfLines={1}>
            {coupon.merchant_names.join(' · ')}
          </Text>
        ) : null}
        <View style={styles.metaRow}>
          <Text style={styles.points}>{coupon.required_points} pts</Text>
          {Number(coupon.discount_amount) > 0 ? (
            <Text style={styles.discount}>{formatRinggit(coupon.discount_amount)} off</Text>
          ) : null}
        </View>
      </View>
    </Card>
  );
}

/** Redemption QR dialog (coupon_qrcode_dialog parity) — the merchant app scans this. */
export function CouponQrDialog({
  coupon,
  visible,
  onClose,
}: {
  coupon: AnyCoupon | null;
  visible: boolean;
  onClose: () => void;
}) {
  const payload = coupon ? coupon.qrcode || coupon.sn : '';
  return (
    <Modal visible={visible && !!coupon} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.qrOverlay}>
        <View style={styles.qrDialog}>
          <Text style={styles.qrTitle} numberOfLines={1}>
            {coupon?.name ?? ''}
          </Text>
          <Text style={styles.qrHint}>Show this code to the merchant</Text>
          {payload ? <QrCodeView value={payload} size={200} style={styles.qr} /> : null}
          {coupon?.sn ? <Text style={styles.qrSn}>{coupon.sn}</Text> : null}
          <Button title="Close" variant="outline" onPress={onClose} style={styles.qrClose} />
        </View>
      </View>
    </Modal>
  );
}

/**
 * Redeem / Use-Now actions (coupon_redeem_actions parity):
 * confirm → POST /app/coupon/redeem → toast + QR dialog with the new coupon.
 */
export function useCouponActions() {
  const queryClient = useQueryClient();
  const [qrCoupon, setQrCoupon] = useState<AnyCoupon | null>(null);
  const [redeemTarget, setRedeemTarget] = useState<AnyCoupon | null>(null);

  const redeemMutation = useMutation({
    mutationFn: (couponId: number) => redeemCoupon(couponId),
    onSuccess: (response) => {
      Toast.success('Coupon redeemed');
      setQrCoupon(response.item);
      void queryClient.invalidateQueries({ queryKey: ['user-profile'] });
      void queryClient.invalidateQueries({ queryKey: ['my-coupon-count'] });
      void queryClient.invalidateQueries({ queryKey: ['my-coupons'] });
      void queryClient.invalidateQueries({ queryKey: ['coupon-list'] });
    },
    onError: (error) => Toast.error(apiErrorMessage(error)),
  });

  const confirmRedeem = (coupon: AnyCoupon) => {
    setRedeemTarget(coupon);
  };

  const showQr = (coupon: AnyCoupon) => setQrCoupon(coupon);
  const closeQr = () => setQrCoupon(null);

  const redeemDialog = redeemTarget ? (
    <ConfirmDialog
      visible
      title="Redeem coupon"
      message={`Redeem "${redeemTarget.name}" for ${redeemTarget.required_points} points?`}
      confirmText="Redeem"
      onCancel={() => setRedeemTarget(null)}
      onConfirm={() => {
        redeemMutation.mutate(redeemTarget.id);
        setRedeemTarget(null);
      }}
    />
  ) : null;

  return {
    confirmRedeem,
    showQr,
    closeQr,
    qrCoupon,
    redeeming: redeemMutation.isPending,
    redeemDialog,
  };
}

/** Small validity line used on cards/detail (`Valid for 30 days` / expiry date). */
export function couponValidityLabel(coupon: AnyCoupon): string {
  if (coupon.expire_at) {
    return `Valid until ${formatSimpleDate(coupon.expire_at)}`;
  }
  if (coupon.valid_days > 0) {
    return `Valid for ${coupon.valid_days} days after redemption`;
  }
  return 'No expiry';
}

const styles = StyleSheet.create({
  card: {
    flexDirection: 'row',
    overflow: 'hidden',
    marginHorizontal: spacing.lg,
    marginBottom: spacing.md,
  },
  image: {
    width: 96,
    height: 96,
    backgroundColor: coreColors.divider,
  },
  body: {
    flex: 1,
    padding: spacing.md,
    gap: 2,
  },
  name: {
    ...textStyles.body,
    fontWeight: '600',
  },
  merchants: {
    ...textStyles.caption,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    marginTop: spacing.xs,
  },
  points: {
    ...textStyles.bodySmall,
    color: userAccentColors.pointsDeal,
    fontWeight: '700',
  },
  discount: {
    ...textStyles.caption,
    color: coreColors.darkGreen,
    fontWeight: '600',
  },
  qrOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  qrDialog: {
    backgroundColor: coreColors.white,
    borderRadius: radii.card,
    padding: spacing.xl,
    alignSelf: 'stretch',
    alignItems: 'center',
  },
  qrTitle: {
    ...textStyles.heading3,
  },
  qrHint: {
    ...textStyles.caption,
    marginTop: spacing.xs,
  },
  qr: {
    marginVertical: spacing.lg,
  },
  qrSn: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  qrClose: {
    marginTop: spacing.lg,
  },
});
