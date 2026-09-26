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

import { useIsLoggedIn, type UserCouponItem, type VoucherStatus } from '@neast/types';
import {
  EmptyState,
  radii,
  RewardCard,
  SectionHeader,
  spacing,
  textStyles,
  userHomeColors,
  VoucherCard,
  type VoucherCardStatus,
} from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { getMyCoupons, getRewardDashboard } from '@/lib/endpoints';
import { useSelectionStore } from '@/stores/selection';
import { CouponQrDialog, useCouponActions } from '@/features/coupon/components';
import { PointsSummaryCard } from './components/PointsSummaryCard';

type VoucherFilter = 'All' | VoucherCardStatus;

/** Reward tab: points, tier, featured merchant vouchers, and my vouchers. */
export function RewardTab() {
  const insets = useSafeAreaInsets();
  const isLoggedIn = useIsLoggedIn();
  const setCoupon = useSelectionStore((state) => state.setCoupon);
  const couponActions = useCouponActions();
  const [voucherFilter, setVoucherFilter] = useState<VoucherFilter>('All');

  const dashboard = useQuery({
    queryKey: ['reward-dashboard'],
    queryFn: () => getRewardDashboard(null),
  });

  const voucherQueries = useQueries({
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
  const vouchersByStatus = {
    Active: voucherQueries[0]?.data?.items ?? [],
    Used: voucherQueries[1]?.data?.items ?? [],
    Expired: voucherQueries[2]?.data?.items ?? [],
  };
  const visibleVouchers = (
    voucherFilter === 'All'
      ? [...vouchersByStatus.Active, ...vouchersByStatus.Used, ...vouchersByStatus.Expired]
      : vouchersByStatus[voucherFilter]
  ).slice(0, 4);
  const hasVouchers =
    vouchersByStatus.Active.length + vouchersByStatus.Used.length + vouchersByStatus.Expired.length >
    0;
  const vouchersPending = voucherQueries.some((query) => query.isLoading);

  const openVoucher = (item: UserCouponItem) => {
    if (item.voucher_status === 'active') {
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
              dashboard.isRefetching || voucherQueries.some((query) => query.isRefetching)
            }
            onRefresh={() => {
              void dashboard.refetch();
              if (!isLoggedIn) return;
              for (const query of voucherQueries) {
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
                message="Redeemable vouchers appear here."
                messageStyle={styles.emptyMessage}
              />
            ) : null}
          </View>

          <View>
            <SectionHeader
              title="My Vouchers"
              titleStyle={styles.sectionTitle}
              actionLabel="View all"
              onActionPress={() =>
                router.push(isLoggedIn ? '/coupon/my-vouchers' : '/login')
              }
            />
            {hasVouchers ? (
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.chips}
              >
                {(['All', 'Active', 'Used', 'Expired'] as const).map((filter) => {
                  const selected = voucherFilter === filter;
                  return (
                    <Pressable
                      key={filter}
                      accessibilityRole="button"
                      onPress={() => setVoucherFilter(filter)}
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
            {vouchersPending ? null : visibleVouchers.length > 0 ? (
              <View style={styles.voucherList}>
                {visibleVouchers.map((item) => (
                  <VoucherCard
                    key={item.user_coupon_id}
                    title={item.name}
                    merchant={item.merchant_names.join(' · ')}
                    status={voucherStatusLabel(item.voucher_status)}
                    image={item.image ? { uri: item.image } : undefined}
                    onPress={() => openVoucher(item)}
                  />
                ))}
              </View>
            ) : (
              <EmptyState
                title={
                  voucherFilter === 'All'
                    ? 'No vouchers'
                    : `No ${voucherFilter.toLowerCase()} vouchers`
                }
                message="Redeem vouchers with your points from the catalog."
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
    </View>
  );
}

function voucherStatusLabel(status: VoucherStatus): VoucherCardStatus {
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
  voucherList: {
    paddingHorizontal: spacing.lg,
    gap: spacing.sm,
  },
});
