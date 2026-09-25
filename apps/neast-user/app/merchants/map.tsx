import { useMemo, useState } from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import MapView, { Marker, UrlTile } from 'react-native-maps';

import { type NearbyMerchantItem } from '@neast/types';
import { Card, coreColors, radii, spacing, textStyles } from '@neast/ui-mobile';

import { getMerchantCategories, getNearbyMerchants } from '../../src/lib/endpoints';
import { useDeviceLocation } from '../../src/lib/location';
import { ErrorState, LoadingState } from '../../src/components/StateViews';
import { PageHeader } from '../../src/components/PageHeader';
import { Screen } from '../../src/components/Screen';

const OSM_TILE_URL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
/** Flutter parity: hardcoded promo chip prepended to server categories. */
const FIVE_X_POINTS_CATEGORY = { id: 5, name: '5X Points' };

/** Merchant map (merchant_map_screen parity): OSM tiles, category chips, deals sheet. */
export default function MerchantsMapRoute() {
  // Location-gated (merchantMapProvider parity): no fix → no map.
  const {
    coords,
    loading: locationLoading,
    unavailable: locationUnavailable,
    refetch,
  } = useDeviceLocation();
  const [categoryId, setCategoryId] = useState<number | null>(null);
  const [sheetExpanded, setSheetExpanded] = useState(true);

  const categories = useQuery({
    queryKey: ['merchant-categories'],
    queryFn: getMerchantCategories,
    staleTime: 5 * 60 * 1000,
  });

  const nearby = useQuery({
    queryKey: ['nearby-merchants', coords?.latitude, coords?.longitude, categoryId],
    queryFn: () => getNearbyMerchants(coords!, categoryId ?? undefined),
    enabled: !!coords,
  });

  const chips = useMemo(
    () => [FIVE_X_POINTS_CATEGORY, ...(categories.data?.items ?? [])],
    [categories.data],
  );

  const merchants = nearby.data?.items ?? [];

  if (locationLoading) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Merchant Map" />
        <LoadingState />
      </Screen>
    );
  }

  if (!coords) {
    return (
      <Screen edges={[]}>
        <PageHeader title="Merchant Map" />
        <ErrorState
          message={
            locationUnavailable
              ? 'Location unavailable — enable location services to see nearby deals.'
              : 'Location unavailable.'
          }
          onRetry={() => refetch()}
        />
      </Screen>
    );
  }

  return (
    <Screen edges={[]}>
      <PageHeader title="Merchant Map" />
      <View style={styles.container}>
        <MapView
          style={styles.map}
          initialRegion={{
            latitude: coords.latitude,
            longitude: coords.longitude,
            latitudeDelta: 0.15,
            longitudeDelta: 0.15,
          }}
          showsUserLocation
        >
          <UrlTile urlTemplate={OSM_TILE_URL} maximumZ={18} minimumZ={3} flipY={false} />
          {merchants.map((merchant) => (
            <Marker
              key={merchant.id}
              coordinate={{
                latitude: Number(merchant.latitude),
                longitude: Number(merchant.longitude),
              }}
              title={merchant.name}
              onCalloutPress={() =>
                router.push({
                  pathname: '/merchant/[id]',
                  params: { id: String(merchant.id) },
                })
              }
            >
              <Image source={{ uri: merchant.image }} style={styles.markerImage} />
            </Marker>
          ))}
        </MapView>

        <View style={styles.chipsWrap}>
          <ScrollView horizontal showsHorizontalScrollIndicator={false}>
            <View style={styles.chipsRow}>
              <CategoryChip
                label="All"
                active={categoryId === null}
                onPress={() => setCategoryId(null)}
              />
              {chips.map((chip) => (
                <CategoryChip
                  key={chip.id}
                  label={chip.name}
                  active={categoryId === chip.id}
                  onPress={() => setCategoryId(chip.id)}
                />
              ))}
            </View>
          </ScrollView>
        </View>

        <View style={styles.sheet}>
          <Pressable
            style={styles.sheetHandle}
            onPress={() => setSheetExpanded((value) => !value)}
            accessibilityRole="button"
          >
            <View style={styles.sheetGrip} />
            <Text style={styles.sheetTitle}>
              Deals Near You{nearby.data ? ` · within ${nearby.data.radius} km` : ''}
            </Text>
          </Pressable>
          {sheetExpanded ? (
            nearby.isLoading ? (
              <LoadingState />
            ) : nearby.isError ? (
              <ErrorState onRetry={() => nearby.refetch()} />
            ) : merchants.length === 0 ? (
              <Text style={styles.sheetEmpty}>
                No deals within {nearby.data?.radius ?? 0} km of you right now.
              </Text>
            ) : (
              <ScrollView style={styles.sheetList}>
                {merchants.map((merchant) => (
                  <NearbyDealRow key={merchant.id} merchant={merchant} />
                ))}
              </ScrollView>
            )
          ) : null}
        </View>
      </View>
    </Screen>
  );
}

function CategoryChip({
  label,
  active,
  onPress,
}: {
  label: string;
  active: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      style={[styles.chip, active && styles.chipActive]}
      onPress={onPress}
      accessibilityRole="button"
    >
      <Text style={[styles.chipText, active && styles.chipTextActive]}>{label}</Text>
    </Pressable>
  );
}

function NearbyDealRow({ merchant }: { merchant: NearbyMerchantItem }) {
  return (
    <Card
      style={styles.dealRow}
      onPress={() =>
        router.push({ pathname: '/merchant/[id]', params: { id: String(merchant.id) } })
      }
    >
      <Image source={{ uri: merchant.image }} style={styles.dealImage} resizeMode="cover" />
      <View style={styles.dealText}>
        <Text style={styles.dealName} numberOfLines={1}>
          {merchant.name}
        </Text>
        {merchant.distance !== null ? (
          <Text style={styles.dealDistance}>{merchant.distance.toFixed(1)} km away</Text>
        ) : null}
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  map: {
    flex: 1,
  },
  markerImage: {
    width: 36,
    height: 36,
    borderRadius: 18,
    borderWidth: 2,
    borderColor: coreColors.white,
    backgroundColor: coreColors.divider,
  },
  chipsWrap: {
    position: 'absolute',
    top: spacing.sm,
    left: 0,
    right: 0,
  },
  chipsRow: {
    flexDirection: 'row',
    gap: spacing.sm,
    paddingHorizontal: spacing.lg,
  },
  chip: {
    backgroundColor: coreColors.white,
    borderRadius: radii.pill,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderWidth: 1,
    borderColor: coreColors.border,
  },
  chipActive: {
    backgroundColor: coreColors.brandBlue,
    borderColor: coreColors.brandBlue,
  },
  chipText: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
  },
  chipTextActive: {
    color: coreColors.white,
    fontWeight: '600',
  },
  sheet: {
    backgroundColor: coreColors.white,
    borderTopLeftRadius: radii.card,
    borderTopRightRadius: radii.card,
    maxHeight: '45%',
  },
  sheetHandle: {
    alignItems: 'center',
    paddingVertical: spacing.sm,
    gap: spacing.xs,
  },
  sheetGrip: {
    width: 36,
    height: 4,
    borderRadius: 2,
    backgroundColor: coreColors.divider,
  },
  sheetTitle: {
    ...textStyles.heading3,
  },
  sheetEmpty: {
    ...textStyles.bodySmall,
    color: coreColors.textSecondary,
    textAlign: 'center',
    padding: spacing.lg,
  },
  sheetList: {
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.lg,
  },
  dealRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    marginBottom: spacing.sm,
    padding: spacing.sm,
  },
  dealImage: {
    width: 48,
    height: 48,
    borderRadius: radii.card,
    backgroundColor: coreColors.divider,
  },
  dealText: {
    flex: 1,
  },
  dealName: {
    ...textStyles.body,
    fontWeight: '500',
  },
  dealDistance: {
    ...textStyles.caption,
    marginTop: 2,
  },
});
