import { ImageBackground, RefreshControl, ScrollView, StyleSheet, View } from 'react-native';
import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn, type MerchantListItem } from '@neast/types';
import { userHomeColors } from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { useDeviceLocation } from '@/lib/location';
import { getHasUnread, getHomeDashboard, getNearbyMerchantList } from '@/lib/endpoints';
import { useUserProfile } from '@/hooks/use-profile';
import {
  AmountCard,
  CampaignCarousel,
  HomeHeader,
  JourneyPromo,
  NearbyDealsGrid,
  PropertyPromo,
} from './components';

/**
 * Home tab — web parity with the tenant app home (NEAST-source apps/neast):
 * header → AmountCard → campaign carousel → Nearby Deals → Your Journey →
 * property promo. Dashboard (including banners) loads for guests and logged-in users.
 */
export function HomeTab() {
  const isLoggedIn = useIsLoggedIn();
  const { coords } = useDeviceLocation();
  const profile = useUserProfile();

  const dashboard = useQuery({
    queryKey: ['home-dashboard', isLoggedIn, coords?.latitude, coords?.longitude],
    queryFn: () => getHomeDashboard(coords),
  });

  // Nearby deals for guests still come from the public merchant list.
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

  const data = dashboard.data;
  const deals: MerchantListItem[] = isLoggedIn
    ? (data?.nearbyDeals ?? [])
    : (guestDeals.data?.items ?? []);

  const refreshing = dashboard.isRefetching || guestDeals.isRefetching || unread.isRefetching;
  const onRefresh = () => {
    void dashboard.refetch();
    if (isLoggedIn) {
      void unread.refetch();
    } else {
      void guestDeals.refetch();
    }
  };

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
            colors={[userHomeColors.emptyGrey]}
            tintColor={userHomeColors.emptyGrey}
          />
        }
        contentContainerStyle={styles.scrollContent}
      >
        <ImageBackground
          source={metallicBackground}
          style={styles.backdrop}
          imageStyle={styles.backdropImage}
        >
          <HomeHeader
            firstName={profile.data?.firstName}
            isLoggedIn={isLoggedIn}
            unreadCount={unread.data?.unread_count ?? 0}
          />
          <View style={styles.homeTop}>
            <AmountCard nextRent={isLoggedIn ? (data?.nextRent ?? null) : null} />
            {dashboard.isSuccess ? (
              <CampaignCarousel banners={dashboard.data.banners} />
            ) : null}
          </View>
        </ImageBackground>

        <View style={styles.homeLower}>
          {deals.length > 0 ? <NearbyDealsGrid deals={deals} /> : null}
          <JourneyPromo streakLabel={data?.journey.streakLabel} />
          <PropertyPromo />
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: userHomeColors.background,
  },
  scrollContent: {
    paddingBottom: 16,
  },
  backdrop: {
    backgroundColor: userHomeColors.navy,
    overflow: 'hidden',
  },
  backdropImage: {
    width: '100%',
    height: '100%',
  },
  homeTop: {
    paddingHorizontal: 14,
    paddingBottom: 12,
    gap: 12,
  },
  homeLower: {
    padding: 14,
    gap: 12,
    backgroundColor: userHomeColors.surface,
    borderTopLeftRadius: 26,
    borderTopRightRadius: 26,
  },
});
