import { useState } from 'react';
import { ImageBackground, Pressable, RefreshControl, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';

import { useIsLoggedIn } from '@neast/types';
import { ComingSoonDialog, userHomeColors } from '@neast/ui-mobile';

import metallicBackground from '@assets/images/home/neast-metallic-background.png';

import { getRentList } from '@/lib/endpoints';
import { ListSkeleton } from '@/components/StateViews';
import { AddTenancyDialog } from './add-tenancy-dialog';
import { AddTenancyCard, ComingSoonTenancyCard, TenancyCard } from './components';

/** Pay Rent tab: tenancy stack and add tenancy. */
export function PayRentTab() {
  const insets = useSafeAreaInsets();
  const isLoggedIn = useIsLoggedIn();

  const [limitVisible, setLimitVisible] = useState(false);
  const [addVisible, setAddVisible] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
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
            <RefreshControl
              refreshing={refreshing}
              onRefresh={() => {
                setRefreshing(true);
                void rents.refetch().finally(() => setRefreshing(false));
              }}
              colors={[userHomeColors.emptyGrey]}
              tintColor={userHomeColors.emptyGrey}
            />
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
            <AddTenancyCard
              label="Sign in to add your first tenancy"
              onPress={() => router.push('/login')}
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
                <AddTenancyCard onPress={() => setAddVisible(true)} />
              )}
            </>
          )}
        </View>
      </ScrollView>
      <Pressable
        accessibilityRole="button"
        onPress={() => {
          if (!isLoggedIn) {
            router.push('/login');
            return;
          }
          if (hasTenancy) {
            setLimitVisible(true);
            return;
          }
          setAddVisible(true);
        }}
        style={({ pressed }) => [styles.addButton, pressed && styles.pressed]}
      >
        <Text style={styles.addButtonText}>Add tenancy</Text>
      </Pressable>
      <AddTenancyDialog visible={addVisible} onClose={() => setAddVisible(false)} />
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
