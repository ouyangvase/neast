import { Image, Pressable, StyleSheet, Text, View, type ImageSourcePropType } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

import { userHomeColors } from '@ui/tokens/colors';
import { radii, spacing } from '@ui/tokens/layout';

export interface RewardCardProps {
  merchant: string;
  title: string;
  points: number;
  image?: ImageSourcePropType;
  onPress?: () => void;
}

/** Navy offer card for a featured reward (merchant, title, points, optional photo). */
export function RewardCard({ merchant, title, points, image, onPress }: RewardCardProps) {
  const content = (
    <View style={styles.inner}>
      <View style={[styles.copy, image ? styles.copyWithImage : null]}>
        <Text style={styles.merchant} numberOfLines={1}>
          {merchant}
        </Text>
        <Text style={styles.title} numberOfLines={2}>
          {title}
        </Text>
        <Text style={styles.points}>{points} points</Text>
      </View>
      {image ? null : <Ionicons name="ribbon-outline" size={40} color={userHomeColors.gold} />}
    </View>
  );

  if (image) {
    return (
      <Pressable
        accessibilityRole="button"
        onPress={onPress}
        style={({ pressed }) => [styles.imageCard, pressed && styles.pressed]}
      >
        <Image source={image} resizeMode="cover" style={styles.image} />
        <View style={styles.shade}>{content}</View>
      </Pressable>
    );
  }

  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={({ pressed }) => [styles.card, pressed && styles.pressed]}
    >
      {content}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: radii.card,
    padding: spacing.md,
    minHeight: 116,
    overflow: 'hidden',
    backgroundColor: userHomeColors.navy,
  },
  imageCard: {
    borderRadius: radii.card,
    overflow: 'hidden',
    minHeight: 112,
    backgroundColor: userHomeColors.navy,
  },
  image: {
    position: 'absolute',
    top: 0,
    right: 0,
    bottom: 0,
    width: '72%',
  },
  shade: {
    backgroundColor: 'rgba(0, 19, 92, 0.2)',
    minHeight: 112,
    padding: 10,
  },
  inner: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  copy: {
    flex: 1,
  },
  copyWithImage: {
    paddingRight: 88,
  },
  merchant: {
    color: userHomeColors.lightCream,
    fontSize: 10,
    fontWeight: '700',
  },
  title: {
    color: userHomeColors.surface,
    fontSize: 17,
    fontWeight: '700',
    marginTop: 4,
  },
  points: {
    color: userHomeColors.lightCream,
    fontSize: 11,
    marginTop: 2,
    fontWeight: '700',
  },
  pressed: {
    opacity: 0.9,
  },
});
