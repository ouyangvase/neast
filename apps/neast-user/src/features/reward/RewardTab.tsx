import { useState } from 'react';
import {
  ImageBackground,
  Pressable,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQueries, useQuery } from '@tanstack/react-query';

import { useIsLoggedIn, type CouponStatus, type UserCouponItem } from '@neast/types';
import {
  CouponCard,
  EmptyState,
  radii,
  RewardCard,
  SectionHeader,
  spacing,
  textStyles,
  userHomeColors,
  type CouponCardStatus,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { getMyCoupons, getRewardDashboard } from '@/lib/endpoints';
import { useSelectionStore } from '@/stores/selection';
import { CouponQrDialog, useCouponActions } from '@/features/coupon/components';
import { PointsSummaryCard } from './components/PointsSummaryCard';

type CouponFilter = 'All' | CouponCardStatus;

/** Reward tab: points, tier, featured merchant coupons, and my coupons. */
export function RewardTab() {
  const insets = useSafeAreaInsets();
  const isLoggedIn = useIsLoggedIn();
  const setCoupon = useSelectionStore((state) => state.setCoupon);
  const couponActions = useCouponActions();
  const [couponFilter, setCouponFilter] = useState<CouponFilter>('All');

  const dashboard = useQuery({
    queryKey: ['reward-dashboard'],
    queryFn: () => getRewardDashboard(null),
  });

  const couponQueries = useQueries({
    queries: (['active', 'used', 'expired'] as const).map((status) => ({
      queryKey: ['my-coupons', 'preview', status],
      queryFn: () => getMyCoupons(1, 4, status),
      enabled: isLoggedIn,
    })),
  });

  const data = dashboard.data;
  const featured = data?.featuredRewards
    .filter((coupon) => coupon.merchant_names.length > 0)
    .slice(0, 2);
  const couponsByStatus = {
    Active: couponQueries[0]?.data?.items ?? [],
    Used: couponQueries[1]?.data?.items ?? [],
    Expired: couponQueries[2]?.data?.items ?? [],
  };
  const visibleCoupons = (
    couponFilter === 'All'
      ? [...couponsByStatus.Active, ...couponsByStatus.Used, ...couponsByStatus.Expired]
      : couponsByStatus[couponFilter]
  ).slice(0, 4);
  const hasCoupons =
    couponsByStatus.Active.length + couponsByStatus.Used.length + couponsByStatus.Expired.length >
    0;
  const couponsPending = couponQueries.some((query) => query.isLoading);

  const openCoupon = (item: UserCouponItem) => {
    if (item.coupon_status === 'active') {
      couponActions.showQr(item);
      return;
    }
    setCoupon(item);
    router.push({ pathname: '/coupon/detail', params: { id: String(item.id) } });
  };

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={
              dashboard.isRefetching || couponQueries.some((query) => query.isRefetching)
            }
            onRefresh={() => {
              void dashboard.refetch();
              if (!isLoggedIn) return;
              for (const query of couponQueries) {
                void query.refetch();
              }
            }}
            colors={[userHomeColors.emptyGrey]}
            tintColor={userHomeColors.emptyGrey}
          />
        }
        contentContainerStyle={styles.scrollContent}
      >
        <TabBackdrop title="Rewards" paddingTop={insets.top + 8} />
        <View style={styles.sheet}>
          {data ? (
            <PointsSummaryCard
              points={data.points}
              pointsExpiringText={data.pointsExpiringText}
              tier={data.tier}
              signedOut={!isLoggedIn}
            />
          ) : null}

          <View>
            <SectionHeader
              title="Featured Rewards"
              titleStyle={styles.sectionTitle}
              actionLabel="View all"
              onActionPress={() => router.push('/coupon')}
            />
            {featured && featured.length > 0 ? (
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.horizontalList}
              >
                {featured.map((coupon) => (
                  <View key={coupon.id} style={styles.rewardSlot}>
                    <RewardCard
                      merchant={coupon.merchant_names.join(' · ')}
                      title={coupon.name}
                      points={coupon.required_points}
                      image={coupon.image ? { uri: coupon.image } : undefined}
                      onPress={() => {
                        if (!isLoggedIn) {
                          router.push('/login');
                          return;
                        }
                        setCoupon(coupon);
                        router.push('/coupon/detail');
                      }}
                    />
                  </View>
                ))}
              </ScrollView>
            ) : data ? (
              <EmptyState
                title="No featured rewards"
                message="Redeemable coupons appear here."
                messageStyle={styles.emptyMessage}
              />
            ) : null}
          </View>

          <View>
            <SectionHeader
              title="My Coupons"
              titleStyle={styles.sectionTitle}
              actionLabel="View all"
              onActionPress={() =>
                router.push(isLoggedIn ? '/coupon/my-coupons' : '/login')
              }
            />
            {hasCoupons ? (
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.chips}
              >
                {(['All', 'Active', 'Used', 'Expired'] as const).map((filter) => {
                  const selected = couponFilter === filter;
                  return (
                    <Pressable
                      key={filter}
                      accessibilityRole="button"
                      onPress={() => setCouponFilter(filter)}
                      style={[styles.chip, selected && styles.chipActive]}
                    >
                      <Text style={[styles.chipText, selected && styles.chipTextActive]}>
                        {filter}
                      </Text>
                    </Pressable>
                  );
                })}
              </ScrollView>
            ) : null}
            {couponsPending ? null : visibleCoupons.length > 0 ? (
              <View style={styles.couponList}>
                {visibleCoupons.map((item) => (
                  <CouponCard
                    key={item.user_coupon_id}
                    title={item.name}
                    merchant={item.merchant_names.join(' · ')}
                    status={couponStatusLabel(item.coupon_status)}
                    image={item.image ? { uri: item.image } : undefined}
                    onPress={() => openCoupon(item)}
                  />
                ))}
              </View>
            ) : (
              <EmptyState
                title={
                  couponFilter === 'All'
                    ? 'No coupons'
                    : `No ${couponFilter.toLowerCase()} coupons`
                }
                message="Redeem coupons with your points from the catalog."
                messageStyle={styles.emptyMessage}
              />
            )}
          </View>
        </View>
      </ScrollView>
      <CouponQrDialog
        coupon={couponActions.qrCoupon}
        visible={!!couponActions.qrCoupon}
        onClose={couponActions.closeQr}
      />
      {couponActions.redeemDialog}
    </View>
  );
}

function couponStatusLabel(status: CouponStatus): CouponCardStatus {
  if (status === 'used') return 'Used';
  if (status === 'expired') return 'Expired';
  return 'Active';
}

function TabBackdrop({ title, paddingTop }: { title: string; paddingTop: number }) {
  return (
    <ImageBackground
      source={metallicBackground}
      resizeMode="cover"
      style={[styles.backdrop, { paddingTop }]}
    >
      <Text style={styles.title}>{title}</Text>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: userHomeColors.surface,
  },
  scrollContent: {
    flexGrow: 1,
  },
  backdrop: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
    paddingHorizontal: 20,
    paddingBottom: 44,
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '700',
    letterSpacing: -0.4,
  },
  sectionTitle: {
    fontSize: 15,
    lineHeight: 20,
  },
  emptyMessage: {
    fontSize: 12,
    lineHeight: 16,
  },
  sheet: {
    flex: 1,
    marginTop: -36,
    paddingTop: 14,
    paddingBottom: spacing.xl,
    gap: spacing.md,
    overflow: 'hidden',
    backgroundColor: userHomeColors.surface,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
  },
  horizontalList: {
    paddingHorizontal: spacing.lg,
    gap: 12,
  },
  rewardSlot: {
    width: 250,
  },
  chips: {
    paddingHorizontal: spacing.lg,
    gap: spacing.sm,
    paddingBottom: spacing.md,
  },
  chip: {
    backgroundColor: userHomeColors.surface,
    borderRadius: radii.pill,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderWidth: 1,
    borderColor: userHomeColors.border,
  },
  chipActive: {
    backgroundColor: userHomeColors.navy,
    borderColor: userHomeColors.navy,
  },
  chipText: {
    ...textStyles.bodySmall,
    color: userHomeColors.textSecondary,
    fontWeight: '700',
  },
  chipTextActive: {
    color: userHomeColors.surface,
  },
  couponList: {
    paddingHorizontal: spacing.lg,
    gap: spacing.sm,
  },
});
