import { Image, Pressable, StyleSheet, Text, View } from 'react-native';
import { router } from 'expo-router';

import type { MerchantListItem } from '@neast/types';
import { SectionHeader, userHomeColors } from '@neast/ui-mobile';

/** Nearby Deals (web parity): "View all" → /merchants + a 3-tile row. */
export function NearbyDealsGrid({ deals }: { deals: MerchantListItem[] }) {
  return (
    <View>
      <SectionHeader
        title="Nearby Deals"
        actionLabel="View all"
        onActionPress={() => router.push('/merchants')}
        style={styles.header}
      />
      <View style={styles.grid}>
        {deals.slice(0, 3).map((deal) => (
          <Pressable
            key={deal.id}
            accessibilityRole="button"
            accessibilityLabel={`Open ${deal.name}`}
            onPress={() => router.push(`/merchant/${deal.id}`)}
            style={styles.tile}
          >
            {deal.image ? (
              <Image source={{ uri: deal.image }} style={styles.artwork} resizeMode="cover" />
            ) : (
              <View style={[styles.artwork, styles.artworkFallback]}>
                <Text style={styles.artworkInitial}>{deal.name.charAt(0)}</Text>
              </View>
            )}
            <Text style={styles.name} numberOfLines={1}>
              {deal.name}
            </Text>
            <Text style={styles.muted} numberOfLines={1}>
              {deal.distance !== null ? `${Math.round(deal.distance * 1000)} m` : deal.address}
            </Text>
          </Pressable>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  header: {
    // Align with homeLower's 14px padding (the shared header defaults to 16).
    paddingHorizontal: 0,
  },
  grid: {
    flexDirection: 'row',
    gap: 10,
  },
  tile: {
    flex: 1,
    minWidth: 0,
    gap: 5,
  },
  artwork: {
    height: 76,
    borderRadius: 10,
    backgroundColor: userHomeColors.lightBlue,
  },
  artworkFallback: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  artworkInitial: {
    color: userHomeColors.royalBlue,
    fontSize: 28,
    fontWeight: '700',
  },
  name: {
    color: userHomeColors.textPrimary,
    fontWeight: '700',
    fontSize: 13,
  },
  muted: {
    color: userHomeColors.textSecondary,
    fontSize: 12,
    lineHeight: 16,
  },
});
