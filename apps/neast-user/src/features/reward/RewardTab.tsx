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
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';

import { formatThousands, useIsLoggedIn, type CouponListItem, type RewardTier } from '@neast/types';
import {
  Card,
  coreColors,
  GuestLoginPlaceholder,
  radii,
  SectionHeader,
  spacing,
  textStyles,
  userAccentColors,
  userHomeColors,
} from '@neast/ui-mobile';

import metallicBackground from '../../../assets/images/home/neast-metallic-background.png';
import myPointsIcon from '../../../assets/images/reward/my-points-icon.png';

import { useDeviceLocation } from '../../lib/location';
import { getRewardDashboard } from '../../lib/endpoints';
import { useSelectionStore } from '../../stores/selection';
import { DealCard } from '../merchant/components';
import { tierIcon } from './tier-icons';

/** Reward tab (reward_screen parity): points, tier progress, featured + nearby rewards. */
export function RewardTab() {
  const insets = useSafeAreaInsets();
  const isLoggedIn = useIsLoggedIn();
  const { coords } = useDeviceLocation();

  const dashboard = useQuery({
    queryKey: ['reward-dashboard', coords?.latitude, coords?.longitude],
    queryFn: () => getRewardDashboard(coords),
    enabled: isLoggedIn,
  });

  if (!isLoggedIn) {
    return (
      <View style={styles.container}>
        <TabBackdrop title="Rewards" paddingTop={insets.top + 8} />
        <View style={styles.sheet}>
          <GuestLoginPlaceholder
            title="Log in to view rewards"
            message="Earn points on rent and spending, then redeem vouchers."
            onLoginPress={() => router.push('/login')}
          />
        </View>
      </View>
    );
  }

  const data = dashboard.data;

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={dashboard.isRefetching}
            onRefresh={() => dashboard.refetch()}
          />
        }
        contentContainerStyle={styles.scrollContent}
      >
        <TabBackdrop title="Rewards" paddingTop={insets.top + 8} />
        <View style={styles.sheet}>
        <Card style={styles.pointsCard} onPress={() => router.push('/points')}>
          <View style={styles.pointsRow}>
            <Image source={myPointsIcon} style={styles.pointsIcon} resizeMode="contain" />
            <View style={styles.pointsTexts}>
              <Text style={styles.pointsLabel}>My Points</Text>
              <Text style={styles.pointsValue}>{formatThousands(data?.points ?? 0)}</Text>
              {data?.pointsExpiringText ? (
                <Text style={styles.pointsExpiring}>{data.pointsExpiringText}</Text>
              ) : null}
            </View>
          </View>
        </Card>

        {data ? <TierProgressCard tier={data.tier} /> : null}

        {data && data.featuredRewards.length > 0 ? (
          <View>
            <SectionHeader
              title="Featured Rewards"
              actionLabel="See all"
              onActionPress={() => router.push('/coupon')}
            />
            <FlatList
              horizontal
              data={data.featuredRewards}
              keyExtractor={(item) => String(item.id)}
              showsHorizontalScrollIndicator={false}
              contentContainerStyle={styles.horizontalList}
              renderItem={({ item }) => <FeaturedRewardCard coupon={item} />}
            />
          </View>
        ) : null}

        {data && data.nearbyRewards.length > 0 ? (
          <View>
            <SectionHeader
              title="Nearby Rewards"
              actionLabel="View map"
              onActionPress={() => router.push('/merchants/map')}
            />
            <FlatList
              horizontal
              data={data.nearbyRewards}
              keyExtractor={(item) => String(item.id)}
              showsHorizontalScrollIndicator={false}
              contentContainerStyle={styles.horizontalList}
              renderItem={({ item }) => (
                <DealCard merchant={item} onPress={() => router.push(`/merchant/${item.id}`)} />
              )}
            />
          </View>
        ) : null}
        </View>
      </ScrollView>
    </View>
  );
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

function TierProgressCard({
  tier,
}: {
  tier: {
    current: RewardTier;
    next: RewardTier | null;
    pointsToNextTier: number;
    progressCurrent: number;
    progressTarget: number;
  };
}) {
  const progress =
    tier.progressTarget > 0 ? Math.min(1, tier.progressCurrent / tier.progressTarget) : 0;
  return (
    <Card style={styles.tierCard} onPress={() => router.push('/reward/tier')}>
      <View style={styles.tierRow}>
        <Image source={tierIcon(tier.current.id)} style={styles.tierIcon} resizeMode="contain" />
        <View style={styles.tierTexts}>
          <Text style={styles.tierName}>{tier.current.name} Tier</Text>
          {tier.next ? (
            <Text style={styles.tierNext}>
              {formatThousands(tier.pointsToNextTier)} pts to {tier.next.name}
            </Text>
          ) : (
            <Text style={styles.tierNext}>Highest tier reached</Text>
          )}
        </View>
      </View>
      <View style={styles.progressTrack}>
        <View style={[styles.progressFill, { width: `${progress * 100}%` }]} />
      </View>
    </Card>
  );
}

function FeaturedRewardCard({ coupon }: { coupon: CouponListItem }) {
  const setCoupon = useSelectionStore((state) => state.setCoupon);
  return (
    <Pressable
      style={styles.rewardItem}
      onPress={() => {
        setCoupon(coupon);
        router.push('/coupon/detail');
      }}
      accessibilityRole="button"
    >
      <Image source={{ uri: coupon.image }} style={styles.rewardImage} resizeMode="cover" />
      <Text style={styles.rewardName} numberOfLines={1}>
        {coupon.name}
      </Text>
      <Text style={styles.rewardPoints}>{coupon.required_points} pts</Text>
    </Pressable>
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
  pointsCard: {
    marginHorizontal: spacing.lg,
    backgroundColor: userAccentColors.tierBackground,
  },
  pointsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  pointsIcon: {
    width: 44,
    height: 44,
  },
  pointsTexts: {
    flex: 1,
  },
  pointsLabel: {
    ...textStyles.caption,
    color: userAccentColors.tierText,
  },
  pointsValue: {
    ...textStyles.numeric,
    color: userAccentColors.tierText,
  },
  pointsExpiring: {
    ...textStyles.caption,
    color: coreColors.error,
    marginTop: 2,
  },
  tierCard: {
    marginHorizontal: spacing.lg,
  },
  tierRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  tierIcon: {
    width: 44,
    height: 44,
  },
  tierTexts: {
    flex: 1,
  },
  tierName: {
    ...textStyles.heading3,
  },
  tierNext: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
    marginTop: 2,
  },
  progressTrack: {
    height: 8,
    borderRadius: radii.pill,
    backgroundColor: coreColors.divider,
    marginTop: spacing.md,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: radii.pill,
    backgroundColor: coreColors.actionGreen,
  },
  horizontalList: {
    paddingHorizontal: spacing.lg,
  },
  rewardItem: {
    width: 140,
    marginRight: spacing.md,
  },
  rewardImage: {
    width: 140,
    height: 96,
    borderRadius: radii.card,
    backgroundColor: coreColors.divider,
  },
  rewardName: {
    ...textStyles.bodySmall,
    fontWeight: '600',
    marginTop: spacing.sm,
  },
  rewardPoints: {
    ...textStyles.caption,
    color: userAccentColors.pointsDeal,
    marginTop: 2,
  },
});
