import { Image, Pressable, StyleSheet, Text, View } from 'react-native';

import type { MerchantListItem } from '@neast/types';
import { Card, coreColors, radii, spacing, textStyles, userAccentColors } from '@neast/ui-mobile';

/** Distance label (`1.2 km away`); null when the caller sent no coordinates. */
export function distanceLabel(distance: number | null | undefined): string | null {
  if (distance === null || distance === undefined) {
    return null;
  }
  return `${distance.toFixed(1)} km away`;
}

interface MerchantCardProps {
  merchant: MerchantListItem;
  onPress?: () => void;
}

/** Merchant list row (deal_card / suggested_merchant_item parity). */
export function MerchantCard({ merchant, onPress }: MerchantCardProps) {
  const distance = distanceLabel(merchant.distance);
  return (
    <Card onPress={onPress} style={styles.card} padded={false}>
      <Image source={{ uri: merchant.image }} style={styles.image} resizeMode="cover" />
      <View style={styles.body}>
        <Text style={styles.name} numberOfLines={1}>
          {merchant.name}
        </Text>
        <Text style={styles.address} numberOfLines={1}>
          {merchant.address}
        </Text>
        <View style={styles.metaRow}>
          {merchant.special_deal ? (
            <View style={styles.dealChip}>
              <Text style={styles.dealChipText}>{merchant.special_deal}</Text>
            </View>
          ) : null}
          {distance ? <Text style={styles.distance}>{distance}</Text> : null}
        </View>
      </View>
    </Card>
  );
}

/** Compact horizontal card for home/reward deal sections. */
export function DealCard({ merchant, onPress }: MerchantCardProps) {
  return (
    <Pressable style={styles.dealCard} onPress={onPress} accessibilityRole="button">
      <Image source={{ uri: merchant.image }} style={styles.dealImage} resizeMode="cover" />
      <Text style={styles.dealName} numberOfLines={1}>
        {merchant.name}
      </Text>
      {merchant.special_deal ? (
        <Text style={styles.dealText} numberOfLines={1}>
          {merchant.special_deal}
        </Text>
      ) : null}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    flexDirection: 'row',
    overflow: 'hidden',
    marginHorizontal: spacing.lg,
    marginBottom: spacing.md,
  },
  image: {
    width: 96,
    height: 96,
    backgroundColor: coreColors.divider,
  },
  body: {
    flex: 1,
    padding: spacing.md,
    gap: 2,
  },
  name: {
    ...textStyles.body,
    fontWeight: '600',
  },
  address: {
    ...textStyles.caption,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    marginTop: spacing.xs,
  },
  dealChip: {
    backgroundColor: userAccentColors.tierBackground,
    borderRadius: radii.pill,
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
  },
  dealChipText: {
    ...textStyles.caption,
    color: userAccentColors.pointsDeal,
    fontWeight: '600',
  },
  distance: {
    ...textStyles.caption,
    color: coreColors.textSecondary,
  },
  dealCard: {
    width: 140,
    marginRight: spacing.md,
  },
  dealImage: {
    width: 140,
    height: 96,
    borderRadius: radii.card,
    backgroundColor: coreColors.divider,
  },
  dealName: {
    ...textStyles.bodySmall,
    fontWeight: '600',
    marginTop: spacing.sm,
  },
  dealText: {
    ...textStyles.caption,
    color: userAccentColors.pointsDeal,
    marginTop: 2,
  },
});
