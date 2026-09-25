import { useState } from 'react';
import { ImageBackground, Pressable, RefreshControl, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn } from '@neast/types';
import { ComingSoonDialog, GuestLoginPlaceholder, userHomeColors } from '@neast/ui-mobile';

import metallicBackground from '../../../assets/images/home/neast-metallic-background.png';
import unloginImage from '../../../assets/images/pay_rent/unlogin.png';

import { getRentList } from '../../lib/endpoints';
import { ListSkeleton } from '../../components/StateViews';
import { AddTenancyCard, ComingSoonTenancyCard, TenancyCard } from './components';

/** Pay Rent tab: tenancy stack and add tenancy. */
export function PayRentTab() {
  const insets = useSafeAreaInsets();
  const isLoggedIn = useIsLoggedIn();

  const [limitVisible, setLimitVisible] = useState(false);
  const rents = useQuery({
    queryKey: ['rent-list'],
    queryFn: getRentList,
    enabled: isLoggedIn,
  });
  const hasTenancy = (rents.data?.items.length ?? 0) > 0;

  return (
    <View style={styles.container}>
      <ScrollView
        refreshControl={
          isLoggedIn ? (
            <RefreshControl refreshing={rents.isRefetching} onRefresh={() => void rents.refetch()} />
          ) : undefined
        }
        contentContainerStyle={styles.scrollContent}
      >
        <ImageBackground
          source={metallicBackground}
          resizeMode="cover"
          style={[styles.backdrop, { paddingTop: insets.top + 8 }]}
        >
          <Text style={styles.title}>Pay Rent</Text>
        </ImageBackground>

        <View style={styles.sheet}>
          {!isLoggedIn ? (
            <GuestLoginPlaceholder
              image={unloginImage}
              title="Log in to pay rent"
              message="Connect your tenancy and pay rent in a few taps."
              onLoginPress={() => router.push('/login')}
            />
          ) : rents.isLoading ? (
            <ListSkeleton rows={2} />
          ) : (
            <>
              {(rents.data?.items ?? []).map((rent) => (
                <TenancyCard key={rent.id} rent={rent} />
              ))}
              {hasTenancy ? (
                <>
                  <ComingSoonTenancyCard />
                  <ComingSoonTenancyCard />
                </>
              ) : (
                <AddTenancyCard />
              )}
            </>
          )}
        </View>
      </ScrollView>
      {isLoggedIn ? (
        <Pressable
          accessibilityRole="button"
          onPress={() => {
            if (hasTenancy) {
              setLimitVisible(true);
              return;
            }
            router.push('/pay-rent/create');
          }}
          style={({ pressed }) => [styles.addButton, pressed && styles.pressed]}
        >
          <Text style={styles.addButtonText}>Add tenancy</Text>
        </Pressable>
      ) : null}
      <ComingSoonDialog
        visible={limitVisible}
        message="You already have a tenancy. Adding another home is coming soon."
        onClose={() => setLimitVisible(false)}
      />
    </View>
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
    padding: 14,
    paddingBottom: 78,
    gap: 8,
    overflow: 'hidden',
    backgroundColor: userHomeColors.surface,
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
  },
  addButton: {
    position: 'absolute',
    left: 14,
    right: 14,
    bottom: 16,
    minHeight: 46,
    borderRadius: 11,
    backgroundColor: userHomeColors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 16,
  },
  addButtonText: {
    color: userHomeColors.surface,
    fontSize: 14,
    fontWeight: '600',
  },
  pressed: {
    opacity: 0.7,
  },
});
