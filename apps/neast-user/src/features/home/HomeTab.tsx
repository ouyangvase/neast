import {
  FlatList,
  Image,
  ImageBackground,
  Pressable,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';

import {
  formatRinggit,
  useIsLoggedIn,
  type CouponLatestItem,
  type HomeBanner,
  type MerchantListItem,
  type RentListItem,
} from '@neast/types';
import {
  Card,
  coreColors,
  GuestLoginPlaceholder,
  radii,
  SectionHeader,
  spacing,
  textStyles,
  userAccentColors,
} from '@neast/ui-mobile';

import homeBg from '../../../assets/images/home/home_bg.png';
import logo from '../../../assets/images/home/hone_logo.png';
import msgIcon from '../../../assets/images/home/msg-icon.png';
import qrIcon from '../../../assets/images/home/qr_icon.png';
import voucherIcon from '../../../assets/images/home/my-voucher-icon.png';

import { useDeviceLocation } from '../../lib/location';
import {
  getHasUnread,
  getHomeDashboard,
  getMyCouponCount,
  getNearbyMerchantList,
} from '../../lib/endpoints';
import { useUserProfile } from '../../hooks/use-profile';
import { useSelectionStore } from '../../stores/selection';
import { DealCard } from '../merchant/components';

/** Home tab (home_screen.dart parity): dashboard + location-aware deals. */
export function HomeTab() {
  const isLoggedIn = useIsLoggedIn();
  const { coords } = useDeviceLocation();
  const profile = useUserProfile();

  const dashboard = useQuery({
    queryKey: ['home-dashboard', coords?.latitude, coords?.longitude],
    queryFn: () => getHomeDashboard(coords),
    enabled: isLoggedIn,
  });

  // Guests can't call /app/home/dashboard — show the public nearby list instead.
  const guestDeals = useQuery({
    queryKey: ['home-guest-deals', coords?.latitude, coords?.longitude],
    queryFn: () =>
      getNearbyMerchantList({
        page: 1,
        limit: 10,
        latitude: coords?.latitude,
        longitude: coords?.longitude,
      }),
    enabled: !isLoggedIn && !!coords,
  });

  const unread = useQuery({
    queryKey: ['has-unread'],
    queryFn: getHasUnread,
    enabled: isLoggedIn,
  });

  const voucherCount = useQuery({
    queryKey: ['my-coupon-count'],
    queryFn: getMyCouponCount,
    enabled: isLoggedIn,
  });

  const data = dashboard.data;
  const deals: MerchantListItem[] = isLoggedIn
    ? (data?.nearbyDeals ?? [])
    : (guestDeals.data?.items ?? []);

  const refreshing = dashboard.isRefetching || guestDeals.isRefetching;
  const onRefresh = () => {
    if (isLoggedIn) {
      void dashboard.refetch();
    } else {
      void guestDeals.refetch();
    }
  };

  const firstName = profile.data?.firstName;

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
        contentContainerStyle={styles.scrollContent}
      >
        <ImageBackground source={homeBg} style={styles.header} resizeMode="cover">
          <View style={styles.headerRow}>
            <Image source={logo} style={styles.logo} resizeMode="contain" />
            <View style={styles.headerActions}>
              {isLoggedIn ? (
                <>
                  <Pressable
                    onPress={() => router.push('/notification')}
                    accessibilityRole="button"
                    accessibilityLabel="Notifications"
                    hitSlop={8}
                  >
                    <View>
                      <Image source={msgIcon} style={styles.headerIcon} resizeMode="contain" />
                      {unread.data?.has_unread ? <View style={styles.unreadDot} /> : null}
                    </View>
                  </Pressable>
                  <Pressable
                    onPress={() => router.push('/account/my-qr')}
                    accessibilityRole="button"
                    accessibilityLabel="My QR"
                    hitSlop={8}
                  >
                    <Image source={qrIcon} style={styles.headerIcon} resizeMode="contain" />
                  </Pressable>
                </>
              ) : null}
            </View>
          </View>
          <Text style={styles.greeting}>Hello{firstName ? `, ${firstName}` : ''}</Text>
          {profile.data?.address ? (
            <Text style={styles.address}>{profile.data.address}</Text>
          ) : null}
        </ImageBackground>

        <View style={styles.content}>
          {!isLoggedIn ? (
            <GuestLoginPlaceholder
              onLoginPress={() => router.push('/login')}
              message="Log in to pay rent, earn points and redeem vouchers."
            />
          ) : null}

          {isLoggedIn && data?.nextRent ? <NextRentCard rent={data.nextRent} /> : null}
          {isLoggedIn && data?.todayReward ? <TodaysRewardCard reward={data.todayReward} /> : null}

          {deals.length > 0 ? (
            <View style={styles.section}>
              <SectionHeader
                title="Nearby Deals"
                actionLabel="View map"
                onActionPress={() => router.push('/merchants/map')}
              />
              <FlatList
                horizontal
                data={deals}
                keyExtractor={(item) => String(item.id)}
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.dealList}
                renderItem={({ item }) => (
                  <DealCard merchant={item} onPress={() => router.push(`/merchant/${item.id}`)} />
                )}
              />
            </View>
          ) : null}

          {isLoggedIn && data ? <JourneyStreakCard journey={data.journey} /> : null}

          {isLoggedIn ? (
            <Card onPress={() => router.push('/coupon/my-vouchers')} style={styles.voucherCard}>
              <View style={styles.voucherRow}>
                <Image source={voucherIcon} style={styles.voucherIcon} resizeMode="contain" />
                <View style={styles.voucherTexts}>
                  <Text style={styles.voucherTitle}>My Vouchers</Text>
                  <Text style={styles.voucherSubtitle}>
                    {voucherCount.data?.count ?? 0} voucher
                    {(voucherCount.data?.count ?? 0) === 1 ? '' : 's'} ready to use
                  </Text>
                </View>
              </View>
            </Card>
          ) : null}

          {isLoggedIn && data && data.banners.length > 0 ? (
            <PromoCarousel banners={data.banners} />
          ) : null}
        </View>
      </ScrollView>
    </View>
  );
}

function NextRentCard({ rent }: { rent: RentListItem }) {
  const setRent = useSelectionStore((state) => state.setRent);
  return (
    <Card
      style={styles.nextRent}
      onPress={() => {
        setRent(rent);
        router.push('/pay-rent/detail');
      }}
    >
      <Text style={styles.cardLabel}>Next Rent Due</Text>
      <Text style={styles.nextRentAmount}>{formatRinggit(rent.amount)}</Text>
      <Text style={styles.nextRentProperty} numberOfLines={1}>
        {rent.property_name}
      </Text>
      <Text style={styles.nextRentDue}>
        {rent.due_text}
        {rent.date_label ? ` · ${rent.date_label}` : ''}
      </Text>
    </Card>
  );
}

function TodaysRewardCard({ reward }: { reward: CouponLatestItem }) {
  return (
    <Card style={styles.rewardCard} onPress={() => router.push('/coupon')}>
      <Text style={styles.cardLabel}>Today's Reward</Text>
      <Text style={styles.rewardName} numberOfLines={1}>
        {reward.name}
      </Text>
      <Text style={styles.rewardPoints}>{reward.required_points} pts to redeem</Text>
    </Card>
  );
}

function JourneyStreakCard({
  journey,
}: {
  journey: { maxStreakMonths: number; streakLabel: string; streakStatus: string };
}) {
  return (
    <Card style={styles.journeyCard} onPress={() => router.push('/account/tent-score')}>
      <Text style={styles.cardLabel}>Your Journey</Text>
      <Text style={styles.journeyValue}>{journey.streakLabel}</Text>
      <Text style={styles.journeyStatus}>
        {journey.streakStatus} · Best streak {journey.maxStreakMonths} months
      </Text>
    </Card>
  );
}

/** "For Rent" promo carousel — banner `link` is display-only (Flutter parity). */
function PromoCarousel({ banners }: { banners: HomeBanner[] }) {
  return (
    <FlatList
      horizontal
      pagingEnabled
      data={banners}
      keyExtractor={(item) => String(item.id)}
      showsHorizontalScrollIndicator={false}
      contentContainerStyle={styles.bannerList}
      renderItem={({ item }) => (
        <Image source={{ uri: item.image_url }} style={styles.banner} resizeMode="cover" />
      )}
    />
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  scrollContent: {
    paddingBottom: spacing.xl,
  },
  header: {
    backgroundColor: coreColors.brandBlue,
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  logo: {
    width: 96,
    height: 32,
  },
  headerActions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.lg,
  },
  headerIcon: {
    width: 24,
    height: 24,
  },
  unreadDot: {
    position: 'absolute',
    top: 0,
    right: 0,
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: coreColors.error,
  },
  greeting: {
    ...textStyles.heading1,
    color: coreColors.white,
    marginTop: spacing.lg,
  },
  address: {
    ...textStyles.bodySmall,
    color: coreColors.white,
    opacity: 0.85,
    marginTop: spacing.xs,
  },
  content: {
    backgroundColor: coreColors.white,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    marginTop: -16,
    paddingTop: spacing.lg,
    gap: spacing.md,
  },
  section: {
    marginTop: spacing.sm,
  },
  dealList: {
    paddingHorizontal: spacing.lg,
  },
  cardLabel: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  nextRent: {
    marginHorizontal: spacing.lg,
    backgroundColor: userAccentColors.sectionBackgroundAlt,
  },
  nextRentAmount: {
    ...textStyles.numeric,
    color: coreColors.brandBlue,
    marginTop: spacing.xs,
  },
  nextRentProperty: {
    ...textStyles.body,
    fontWeight: '600',
    marginTop: spacing.xs,
  },
  nextRentDue: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  rewardCard: {
    marginHorizontal: spacing.lg,
    backgroundColor: userAccentColors.tierBackground,
  },
  rewardName: {
    ...textStyles.body,
    fontWeight: '600',
    marginTop: spacing.xs,
  },
  rewardPoints: {
    ...textStyles.caption,
    color: userAccentColors.pointsDeal,
    marginTop: 2,
  },
  journeyCard: {
    marginHorizontal: spacing.lg,
  },
  journeyValue: {
    ...textStyles.heading3,
    marginTop: spacing.xs,
  },
  journeyStatus: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  voucherCard: {
    marginHorizontal: spacing.lg,
  },
  voucherRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  voucherIcon: {
    width: 40,
    height: 40,
  },
  voucherTexts: {
    flex: 1,
  },
  voucherTitle: {
    ...textStyles.body,
    fontWeight: '600',
  },
  voucherSubtitle: {
    ...textStyles.caption,
    marginTop: 2,
  },
  bannerList: {
    paddingHorizontal: spacing.lg,
  },
  banner: {
    width: 320,
    height: 140,
    borderRadius: radii.card,
    backgroundColor: coreColors.divider,
    marginRight: spacing.md,
  },
});
