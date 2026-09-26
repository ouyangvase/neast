import { useState } from 'react';
import { Image, Linking, Pressable, ScrollView, Share, StyleSheet, Text, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import { BottomSheet, coreColors, spacing, textStyles, Toast, userHomeColors } from '@neast/ui-mobile';

import { getMerchantCoupons, getMerchantDetail } from '@/lib/endpoints';
import { merchantShareUrl } from '@/lib/deep-links';
import { useDeviceLocation } from '@/lib/location';
import { useSelectionStore } from '@/stores/selection';
import { couponValidityLabel } from '@/features/coupon/components';
import { distanceLabel, MerchantCard } from '@/features/merchant/components';
import { ErrorState, LoadingState } from '@/components/StateViews';
import { PageHeader } from '@/components/PageHeader';
import { Screen } from '@/components/Screen';

/** Merchant detail (merchant_detail_screen parity): info, coupons, map, share, nearest. */
export default function MerchantDetailRoute() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const merchantId = Number(id);
  const { coords } = useDeviceLocation();
  const [couponSheetVisible, setCouponSheetVisible] = useState(false);

  const detail = useQuery({
    queryKey: ['merchant-detail', merchantId, coords?.latitude ?? null, coords?.longitude ?? null],
    queryFn: () => getMerchantDetail(merchantId, coords),
    enabled: Number.isFinite(merchantId),
  });

  const coupons = useQuery({
    queryKey: ['merchant-coupons', merchantId],
    queryFn: () => getMerchantCoupons(merchantId),
    enabled: Number.isFinite(merchantId) && couponSheetVisible,
  });

  const merchant = detail.data;

  const openInMaps = () => {
    if (!merchant?.latitude || !merchant.longitude) {
      Toast.error('Location unavailable for this merchant');
      return;
    }
    const url = `https://www.openstreetmap.org/?mlat=${merchant.latitude}&mlon=${merchant.longitude}#map=17/${merchant.latitude}/${merchant.longitude}`;
    void Linking.openURL(url);
  };

  const shareMerchant = async () => {
    if (!merchant) return;
    try {
      await Share.share({
        message: `Check out ${merchant.name} on NEAST: ${merchantShareUrl(merchant.id)}`,
      });
    } catch {
      // user dismissed the share sheet
    }
  };

  return (
    <Screen edges={[]}>
      <PageHeader title={merchant?.name ?? 'Merchant'} />
      {detail.isLoading ? (
        <LoadingState />
      ) : !merchant ? (
        <ErrorState onRetry={() => detail.refetch()} />
      ) : (
        <ScrollView contentContainerStyle={styles.scroll}>
          <Image source={{ uri: merchant.image }} style={styles.hero} resizeMode="cover" />
          <View style={styles.body}>
            <Text style={styles.name}>{merchant.name}</Text>
            <Text style={styles.address}>{merchant.address}</Text>
            {distanceLabel(merchant.distance) ? (
              <Text style={styles.distance}>{distanceLabel(merchant.distance)}</Text>
            ) : null}

            <View style={styles.actionRow}>
              <Pressable
                style={styles.actionButton}
                onPress={() => setCouponSheetVisible(true)}
                accessibilityRole="button"
              >
                <Text style={styles.actionText}>Vouchers</Text>
              </Pressable>
              <Pressable
                style={styles.actionButton}
                onPress={openInMaps}
                accessibilityRole="button"
              >
                <Text style={styles.actionText}>Directions</Text>
              </Pressable>
              <Pressable
                style={styles.actionButton}
                onPress={() => void shareMerchant()}
                accessibilityRole="button"
              >
                <Text style={styles.actionText}>Share</Text>
              </Pressable>
            </View>

            {merchant.nearest_merchant ? (
              <View style={styles.nearestSection}>
                <Text style={styles.sectionTitle}>Nearest alternative</Text>
                <MerchantCard
                  merchant={merchant.nearest_merchant}
                  onPress={() =>
                    router.push({
                      pathname: '/merchant/[id]',
                      params: { id: String(merchant.nearest_merchant?.id ?? '') },
                    })
                  }
                />
              </View>
            ) : null}
          </View>
        </ScrollView>
      )}

      <BottomSheet
        visible={couponSheetVisible}
        onClose={() => setCouponSheetVisible(false)}
        title="Vouchers"
      >
        {coupons.isLoading ? (
          <LoadingState />
        ) : (coupons.data?.items.length ?? 0) === 0 ? (
          <Text style={styles.emptyCoupons}>No vouchers available for this merchant.</Text>
        ) : (
          <View style={styles.couponList}>
            {(coupons.data?.items ?? []).map((coupon) => (
              <Pressable
                key={coupon.id}
                style={styles.couponRow}
                onPress={() => {
                  setCouponSheetVisible(false);
                  useSelectionStore.getState().setCoupon(coupon);
                  router.push({
                    pathname: '/coupon/detail',
                    params: { id: String(coupon.id) },
                  });
                }}
                accessibilityRole="button"
              >
                <View style={styles.couponText}>
                  <Text style={styles.couponName} numberOfLines={1}>
                    {coupon.name}
                  </Text>
                  <Text style={styles.couponMeta}>
                    {coupon.required_points} pts · {couponValidityLabel(coupon)}
                  </Text>
                </View>
              </Pressable>
            ))}
          </View>
        )}
      </BottomSheet>
    </Screen>
  );
}

const styles = StyleSheet.create({
  scroll: {
    paddingBottom: spacing.xxl,
  },
  hero: {
    width: '100%',
    height: 200,
    backgroundColor: coreColors.divider,
  },
  body: {
    padding: spacing.lg,
    gap: spacing.sm,
  },
  name: {
    ...textStyles.heading2,
  },
  address: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  distance: {
    ...textStyles.caption,
  },
  actionRow: {
    flexDirection: 'row',
    gap: spacing.sm,
    marginTop: spacing.sm,
  },
  actionButton: {
    flex: 1,
    borderWidth: 1,
    borderColor: userHomeColors.navy,
    borderRadius: 8,
    paddingVertical: spacing.sm,
    alignItems: 'center',
  },
  actionText: {
    ...textStyles.bodySmall,
    color: userHomeColors.navy,
    fontWeight: '600',
  },
  nearestSection: {
    marginTop: spacing.lg,
    gap: spacing.sm,
  },
  sectionTitle: {
    ...textStyles.heading3,
  },
  emptyCoupons: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    paddingVertical: spacing.lg,
  },
  couponList: {
    gap: spacing.sm,
  },
  couponRow: {
    paddingVertical: spacing.sm,
  },
  couponText: {
    gap: 2,
  },
  couponName: {
    ...textStyles.body,
    fontWeight: '500',
  },
  couponMeta: {
    ...textStyles.caption,
  },
});
